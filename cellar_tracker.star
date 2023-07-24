load("render.star", "render")
load("http.star", "http")
load("encoding/json.star", "json")
load("encoding/csv.star", "csv")
load("re.star", "re")

# convert this:
#   [
#     ["title", "description", "price"],
#     ["oathbreaker", "cool fantasy book", "20.00"],
#     ["rhythm of war", "another cool fantasy book", "25.00"],
#   ]
#
# into this:
#   [
#     {
#	    "title": "oathbreaker",
#	    "description": "cool fantasy book",
#	    "price": "20.00"
#     },
#     {
#	    "title": "rhythm of war",
#	    "description": "another cool fantasy book",
#	    "price": "25.00"
#     },
#   ]
#
def csv_to_dict_list(raw_csv_string):
	csv_rows = csv.read_all(raw_csv_string)
	header_row = csv_rows[0]

	result = []
	for csv_row in csv_rows[1:-1]:
		dict_row = {}
		for index, field_value in enumerate(csv_row):
			field_name = header_row[index]
			dict_row[field_name] = field_value
		result.append(dict_row)
	return result

# Get inventory report which includes private notes
# that we can use for filtering out excluded bottles
def get_inventory(username, password):
	url = "https://www.cellartracker.com/xlquery.asp?User=%s&Password=%s&Format=csv&Table=Inventory"%(username, password)
	resp = http.get(url)
	return resp.body()

# Get availability report which is sorted by ready to drink
def get_availability(username, password):
	url = "https://www.cellartracker.com/xlquery.asp?User=%s&Password=%s&Format=csv&Table=Availability"%(username, password)
	resp = http.get(url)
	return resp.body()

# Return a list of iWine ids for bottles to be excluded from the availability report
#
# Current implementation only excludes wines earmarked for anniversaries
def select_excluded_wine_ids(inventory_list):
	excluded_wine_ids = []
	for bottle in inventory_list:
		if bottle["BottleNote"].startswith("Anniversary"):
			excluded_wine_ids.append(bottle["iWine"])
	return excluded_wine_ids

# Return the next ready-to-drink red from the availability list,
# ignoring any wines in the exclusion list
def find_next_red(availability_list, excluded_wine_ids):
	for bottle in availability_list:
		bottle_id = bottle["iWine"]
		wine_type = bottle["Type"]
		if wine_type == "Red" and bottle_id not in excluded_wine_ids:
			return bottle
	return None

# Return the next ready-to-drink white from the availability list,
# ignoring any wines in the exclusion list
def find_next_white(availability_list, excluded_wine_ids):
	for bottle in availability_list:
		bottle_id = bottle["iWine"]
		wine_type = bottle["Type"]
		if wine_type == "White" and bottle_id not in excluded_wine_ids:
			return bottle
	return None

# Return the next ready-to-drink sparkling from the availability list,
# ignoring any wines in the exclusion list
def find_next_sparkling(availability_list, excluded_wine_ids):
	for bottle in availability_list:
		bottle_id = bottle["iWine"]
		wine_type = bottle["Category"]
		if wine_type == "Sparkling" and bottle_id not in excluded_wine_ids:
			return bottle
	return None

def find_bottle_to_display(wine_type, availability_list, excluded_wine_ids):
	if wine_type == "Red":
		return find_next_red(availability_list, excluded_wine_ids)
	elif wine_type == "White":
		return find_next_white(availability_list, excluded_wine_ids)
	elif wine_type == "Sparkling":
		return find_next_sparkling(availability_list, excluded_wine_ids)
	else:
		return find_next_red(availability_list, excluded_wine_ids)

def wine_display_text(bottle):
	display_text_components = [bottle["Vintage"], bottle["Producer"]]
	if bottle["Designation"] == "Unknown":
		display_text_components.append(bottle["Varietal"])
	else:
		display_text_components.append(bottle["Designation"])
	return " ".join(display_text_components)

# Unfortunately, Starlark doesn't have encoding/decoding functions for
# strings or bytes. Even more unfortunately, CellarTracker returns strings
# encoded in latin1/ISO-8859-1, and Starlark is unable to convert those
# into UTF-8. So, what should be "Cuvée" comes through as "Cuv\xe9e".
#
# Here we will fix specific characters known to be problematic, with
# the hope that eventually Starlark will add bytes encoding+decoding
# and we can solve this more cleanly.
def fix_wine_display_name(display_name):
	return repr(display_name).replace("\\xe9", "é")


def main(config):
	username = config.get("cellartracker_username")
	password = config.get("cellartracker_password")
	if username == None or password == None:
		fail("Cellartracker username and password are required")

	raw_inventory_csv = get_inventory(username, password)
	inventory_list = csv_to_dict_list(raw_inventory_csv)
	excluded_wine_ids = select_excluded_wine_ids(inventory_list)

	raw_availability_csv = get_availability(username, password)
	availability_list = csv_to_dict_list(raw_availability_csv)

	# TODO get this from config
	wine_type_to_display = "Sparkling"

	bottle = find_bottle_to_display(wine_type_to_display, availability_list, excluded_wine_ids)

	return render.Root(
		child = render.Box(
			render.Row(
				expanded = True,
				main_align = "space_evenly",
				cross_align = "center",
				children = [
					render.WrappedText(
						content = "glass icon here",
						width = 12
					),
					render.Marquee(
						scroll_direction = "vertical",
						height = 30,
						offset_start = 20,
						offset_end = 22,
						child = render.WrappedText(
							content = fix_wine_display_name(wine_display_text(bottle)),
							color = "#808080"
						)
					)
				]
			)
		)
		
	)