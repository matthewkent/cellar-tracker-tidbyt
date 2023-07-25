load("encoding/base64.star", "base64")
load("encoding/csv.star", "csv")
load("encoding/json.star", "json")
load("http.star", "http")
load("re.star", "re")
load("render.star", "render")

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

# Use this command to generate base64 data of the image files
#
# python -c 'import base64; print(base64.b64encode(open("images/white-wine-glass.png", "rb").read()).decode("utf-8"))'
#
def get_wine_glass_image_data(wine_type):
	if wine_type == "White":
		return "iVBORw0KGgoAAAANSUhEUgAAAAoAAAAWCAYAAAD5Jg1dAAAAAXNSR0IArs4c6QAAAH1JREFUOE9jPPvi138GIgAjSKGROCtepede/mYYfgr12boZmAWrGP6+b8Pw/ZMHVxjeSi2E+Jo2CnGFOIbV1FMIMgnmIXRTYdYaS7AxMsIkQYqFn8WjqAUFC0gRSBCuEGYyTDGyIgyFMMUgGmYSzAoUEwdIIa68A/c1sZkLAHHel5t001MXAAAAAElFTkSuQmCC"
	if wine_type == "Red":
		return "iVBORw0KGgoAAAANSUhEUgAAAAoAAAAWCAYAAAD5Jg1dAAAAAXNSR0IArs4c6QAAAIFJREFUOE9jPPvi138GIgAjSKGROCtepede/mYYfgp5g60ZVI+cYrhtY4bh+80fPjE47L0M8TVtFOIKcQyrqacQZBLMQ+imwqw1lmBjZIRJghQfcNZFUQsKFpAikCBcIcxkmGJkRRgKYYpBNMwkmBUoJg6gQvT8g+xOsBsJZTCQBgA6R5ftTBH+3wAAAABJRU5ErkJggg=="
	if wine_type == "Sparkling":
		return "iVBORw0KGgoAAAANSUhEUgAAAAkAAAAWCAYAAAASEbZeAAAAAXNSR0IArs4c6QAAAJtJREFUOE9jZGBgYDj74td/EI0NGEuwMTLCFBmJs2KoOffyNwPxikBWYTMFZizINMYBUKTP1o3V+08eXGF4K7UQ4iaQImbBKoa/79vgikH8h+ejUBXBZJEVY5iEzb6Bsg4WwejBAHMPPIJhCoWfxcPdDwofkAKQAJiAAVCYgRQiK8BQBDMRZgJMM4pJ1FOEnNaRrQRHMK5MABMHACiPoD+N8QF/AAAAAElFTkSuQmCC"
	else:
		return "iVBORw0KGgoAAAANSUhEUgAAAAoAAAAWCAYAAAD5Jg1dAAAAAXNSR0IArs4c6QAAAIFJREFUOE9jPPvi138GIgAjSKGROCtepede/mYYfgp5g60ZVI+cYrhtY4bh+80fPjE47L0M8TVtFOIKcQyrqacQZBLMQ+imwqw1lmBjZIRJghQfcNZFUQsKFpAikCBcIcxkmGJkRRgKYYpBNMwkmBUoJg6gQvT8g+xOsBsJZTCQBgA6R5ftTBH+3wAAAABJRU5ErkJggg=="

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
	wine_type_to_display = "White"

	bottle = find_bottle_to_display(wine_type_to_display, availability_list, excluded_wine_ids)

	return render.Root(
		child = render.Box(
			render.Row(
				expanded = True,
				main_align = "start",
				cross_align = "center",
				children = [
					render.Box(
						width = 15,
						child = render.Image(
							src = base64.decode(get_wine_glass_image_data(wine_type_to_display))
						),
					),
					render.Marquee(
						scroll_direction = "vertical",
						height = 32,
						offset_start = 16,
						offset_end = 32,
						child = render.Padding(pad = 1, child = render.WrappedText(
							content = fix_wine_display_name(wine_display_text(bottle)),
							color = "#808080"
						))
					)
				]
			)
		)
		
	)