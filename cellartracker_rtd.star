load("encoding/base64.star", "base64")
load("encoding/csv.star", "csv")

# load("encoding/json.star", "json")
load("http.star", "http")
load("random.star", "random")
load("render.star", "render")
load("xpath.star", "xpath")

AVAILABILITY_TEST_DATA_CSV = """
"iWine","Type","Color","Category","Available","Linear","Bell","Early","Late","Fast","TwinPeak","Simple","Purchases","ActualPurchases","Pending","ActualPending","LocalQuantityActual","LocalQuantity","Consumed","ActualConsumed","Inventory","ActualInventory","Vintage","Wine","SortWine","Locale","Producer","Varietal","MasterVarietal","Designation","Vineyard","Country","Region","SubRegion","Appellation","PersonalBegin","PersonalEnd","WABegin","WAEnd","WSBegin","WSEnd","IWCBegin","IWCEnd","AGBegin","AGEnd","TWFBegin","TWFEnd","BGBegin","BGEnd","WEBegin","WEEnd","JRBegin","JREnd","DRBegin","DREnd","PGBegin","PGEnd","WALBegin","WALEnd","FTLOPBegin","FTLOPEnd","JGBegin","JGEnd","ComBegin","ComEnd","BeginConsume","EndConsume","Source","WA","WAWeb","WASort","WS","WSWeb","WSSort","BG","BGWeb","BGSort","IWC","IWCWeb","IWCSort","AG","AGWeb","AGSort","FTLOP","FTLOPWeb","FTLOPSort","BR","BRWeb","BRSort","GV","GVWeb","GVSort","LF","LFWeb","LFSort","JK","JKWeb","JKSort","JG","JGWeb","JGSort","LD","LDWeb","LDSort","CW","CWWeb","CWSort","WE","WEWeb","WESort","JR","JRWeb","JRSort","WFW","WFWWeb","WFWSort","PR","PRWeb","PRSort","SJ","SJWeb","SJSort","WD","WDWeb","WDSort","GA","GAWeb","GASort","RR","RRWeb","RRSort","JH","JHWeb","JHSort","MFW","MFWWeb","MFWSort","WWR","WWRWeb","WWRSort","IWR","IWRWeb","IWRSort","CHG","CHGWeb","CHGSort","TT","TTWeb","TTSort","TWF","TWFWeb","TWFSort","DR","DRWeb","DRSort","FP","FPWeb","FPSort","JM","JMWeb","JMSort","PG","PGWeb","PGSort","WAL","WALWeb","WALSort","JS","JSWeb","JSSort","PNotes","PScore","PScoreSort","CNotes","CScore","CScoreSort"
"2630586","Red","Red","Dry","0.901404958677686","0.823005819924683","0.901404958677686","0.930702479338843","0.813884297520661","0.982851239669422","0.901404958677686","0.5","1","1","0","0","1","1","0","0","1","1","2014","Clif Family Winery Cabernet Sauvignon Kit's Killer Cab","Clif Family Winery Cabernet Sauvignon Kit's Killer Cab","USA, California, Napa Valley, Howell Mountain","Clif Family Winery","Cabernet Sauvignon","Cabernet Sauvignon","Kit's Killer Cab","Unknown","USA","California","Napa Valley","Howell Mountain","","","","","","","","","","","","","","","","","","","","","","","","","","","","","2017","2024","1/1/2017","12/31/2024","Community","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","6","91.1666666666667","91.1666666666667"
"2587207","Red","Red","Dry","0.901404958677686","0.823005819924683","0.901404958677686","0.930702479338843","0.813884297520661","0.982851239669422","0.901404958677686","0.5","1","1","0","0","1","1","0","0","1","1","2014","Epoch Estate Wines Creativity","Epoch Estate Wines Creativity","USA, California, Central Coast, Paso Robles","Epoch Estate Wines","Mourvèdre","Mourvèdre","Creativity","Unknown","USA","California","Central Coast","Paso Robles","","","","","","","","","","","","","","","","","","","","","","","","","","","","","2017","2024","1/1/2017","12/31/2024","Community","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","21","92.8","92.8"
"3927893","White - Sparkling","White","Sparkling","0.861974405850091","0.861974405850091","0.927777777777778","0.947444444444444","0.876222222222222","0.988555555555556","0.927777777777778","1","1","1","0","0","1","1","0","0","1","1","2017","Iron Horse Vineyards Wedding Cuvée","Iron Horse Vineyards Wedding Cuvée","USA, California, Sonoma County, Green Valley of Russian River Valley","Iron Horse Vineyards","Champagne Blend","Champagne Blend","Wedding Cuvée","Unknown","USA","California","Sonoma County","Green Valley of Russian River Valley","","","","","","","","","","","","","","","","","","","","","","","","","","","","","2021","2023","1/1/2021","12/31/2023","Community","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","10","90.6666666666667","90.6666666666667"
"4367782","White","White","Dry","0.734277777777778","0.527853881278539","0.541333333333333","0.734277777777778","0.331166666666667","0.858944444444445","0.521333333333333","0.5","1","1","0","0","1","1","0","0","1","1","2021","Lioco Sauvignon Blanc Lolonis Vineyard","Lioco Sauvignon Blanc Lolonis Vineyard","USA, California, North Coast, Redwood Valley","Lioco","Sauvignon Blanc","Sauvignon Blanc","Unknown","Lolonis Vineyard","USA","California","North Coast","Redwood Valley","","","","","","","","","","","","","","","","","","","","","","","","","","","","","2022","2024","1/1/2022","12/31/2024","Community","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","1","90","90"
"4250600","White","White","Dry","0.721887417218543","0.516712328767123","0.523841059602649","0.721887417218543","0.315860927152318","0.850927152317881","0.503841059602649","0.333333333333333","1","1","0","0","1","1","0","0","1","1","2020","Abbot's Passage Noontide","Abbot's Passage Noontide","USA, California, Sonoma County, Sonoma Valley","Abbot's Passage","White Blend","White Blend","Noontide","Unknown","USA","California","Sonoma County","Sonoma Valley","","","","","","","","","","","","","","","","","","","","","","","","","","","","","2021","2025","1/1/2021","12/31/2025","Community","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","0","",""
"3200359","White - Sparkling","White","Sparkling","0.716867469879518","0.716867469879518","0.790927152317881","0.877417218543046","0.621390728476821","0.953278145695364","0.787019867549669","0.5","1","1","0","0","1","1","0","0","1","1","2014","Iron Horse Vineyards Chinese Cuvee","Iron Horse Vineyards Chinese Cuvee","USA, California, Sonoma County, Green Valley of Russian River Valley","Iron Horse Vineyards","Champagne Blend","Champagne Blend","Chinese Cuvee","Unknown","USA","California","Sonoma County","Green Valley of Russian River Valley","","","","","","","","","","","","","","","","","","","","","","","","","","","","","2020","2024","1/1/2020","12/31/2024","Community","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","7","91.8571428571429","91.8571428571429"
"3404098","Red","Red","Dry","0.523841059602649","0.516712328767123","0.523841059602649","0.721887417218543","0.315860927152318","0.850927152317881","0.503841059602649","0.333333333333333","1","1","0","0","1","1","0","0","1","1","2018","Vallone di Cecione Canaiolo","Vallone di Cecione Canaiolo","Italy, Tuscany, Toscana IGT","Vallone di Cecione","Canaiolo","Canaiolo","Unknown","Unknown","Italy","Tuscany","Unknown","Toscana IGT","","","","","","","","","","","","","","","","","","","","","","","","","","","","","2021","2025","1/1/2021","12/31/2025","Community","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","0","",""
"""

INVENTORY_TEST_DATA_CSV = """
"iWine","Barcode","Location","Bin","Size","Currency","ExchangeRate","Valuation","Price","NativePrice","NativePriceCurrency","StoreName","PurchaseDate","BottleNote","Vintage","Wine","Locale","Country","Region","SubRegion","Appellation","Producer","SortProducer","Type","Color","Category","Varietal","MasterVarietal","Designation","Vineyard","WA","WS","IWC","BH","AG","WE","JR","RH","JG","GV","JK","LD","CW","WFW","PR","SJ","WD","RR","JH","MFW","WWR","IWR","CHG","TT","TWF","DR","FP","JM","PG","WAL","JS","CT","CNotes","MY","PNotes","BeginConsume","EndConsume","PurchasedCommunity","QuantityCommunity","PendingCommunity","ConsumedCommunity"
"2630586","0170254219","Library","","750ml","USD","1","0","0","0","USD","Unknown","12/4/2022","","2014","Clif Family Winery Cabernet Sauvignon Kit's Killer Cab","USA, California, Napa Valley, Howell Mountain","USA","California","Napa Valley","Howell Mountain","Clif Family Winery","Clif Family Winery","Red","Red","Dry","Cabernet Sauvignon","Cabernet Sauvignon","Kit's Killer Cab","Unknown","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","91.1666666666667","6","","","2017","2024","307","145","0","162"
"2587207","0170254355","Library","","750ml","USD","1","0","0","0","USD","Unknown","12/4/2022","Anniversary 2024","2014","Epoch Estate Wines Creativity","USA, California, Central Coast, Paso Robles","USA","California","Central Coast","Paso Robles","Epoch Estate Wines","Epoch Estate Wines","Red","Red","Dry","Mourvèdre","Mourvèdre","Creativity","Unknown","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","92.8","21","","","2017","2024","305","127","0","178"
"3927893","0170254643","Library","","750ml","USD","1","0","0","0","USD","Unknown","12/4/2022","","2017","Iron Horse Vineyards Wedding Cuvée","USA, California, Sonoma County, Green Valley of Russian River Valley","USA","California","Sonoma County","Green Valley of Russian River Valley","Iron Horse Vineyards","Iron Horse Vineyards","White - Sparkling","White","Sparkling","Champagne Blend","Champagne Blend","Wedding Cuvée","Unknown","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","90.6666666666667","10","","","2021","2023","401","205","0","196"
"4367782","0173673931","Cellar","Right rack","750ml","USD","1","0","0","0","USD","Unknown","2/27/2023","","2021","Lioco Sauvignon Blanc Lolonis Vineyard","USA, California, North Coast, Redwood Valley","USA","California","North Coast","Redwood Valley","Lioco","Lioco","White","White","Dry","Sauvignon Blanc","Sauvignon Blanc","Unknown","Lolonis Vineyard","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","90","1","","","2022","2024","52","24","0","28"
"4250600","0170253600","Cellar","Right rack","750ml","USD","1","0","0","0","USD","Unknown","12/4/2022","","2020","Abbot's Passage Noontide","USA, California, Sonoma County, Sonoma Valley","USA","California","Sonoma County","Sonoma Valley","Abbot's Passage","Abbot's Passage","White","White","Dry","White Blend","White Blend","Noontide","Unknown","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","0","","","2021","2025","35","16","0","19"
"3200359","0170254639","Library","","750ml","USD","1","0","0","0","USD","Unknown","12/4/2022","","2014","Iron Horse Vineyards Chinese Cuvee","USA, California, Sonoma County, Green Valley of Russian River Valley","USA","California","Sonoma County","Green Valley of Russian River Valley","Iron Horse Vineyards","Iron Horse Vineyards","White - Sparkling","White","Sparkling","Champagne Blend","Champagne Blend","Chinese Cuvee","Unknown","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","91.8571428571429","7","","","2020","2024","286","100","0","186"
"3404098","0177692955","Library","","750ml","USD","1","0","0","0","USD","Unknown","6/3/2023","","2018","Vallone di Cecione Canaiolo","Italy, Tuscany, Toscana IGT","Italy","Tuscany","Unknown","Toscana IGT","Vallone di Cecione","Vallone di Cecione","Red","Red","Dry","Canaiolo","Canaiolo","Unknown","Unknown","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","0","","","2021","2025","6","4","0","2"
"""

AVAILABILITY_TEST_DATA_XML = """
<cellartracker>
  <availability>
    <row>
      <iWine>2630586</iWine>
      <Type>Red</Type>
      <Color>Red</Color>
      <Category>Dry</Category>
      <Available>0.901735537190083</Available>
      <Linear>0.823348168435467</Linear>
      <Bell>0.901735537190083</Bell>
      <Early>0.930867768595041</Early>
      <Late>0.814504132231405</Late>
      <Fast>0.982933884297521</Fast>
      <TwinPeak>0.901735537190083</TwinPeak>
      <Simple>0.5</Simple>
      <Purchases>1</Purchases>
      <ActualPurchases>1</ActualPurchases>
      <Pending>0</Pending>
      <ActualPending>0</ActualPending>
      <LocalQuantityActual>1</LocalQuantityActual>
      <LocalQuantity>1</LocalQuantity>
      <Consumed>0</Consumed>
      <ActualConsumed>0</ActualConsumed>
      <Inventory>1</Inventory>
      <ActualInventory>1</ActualInventory>
      <Vintage>2014</Vintage>
      <Wine>Clif Family Winery Cabernet Sauvignon Kit&#39;s Killer Cab</Wine>
      <SortWine>Clif Family Winery Cabernet Sauvignon Kit&#39;s Killer Cab</SortWine>
      <Locale>USA, California, Napa Valley, Howell Mountain</Locale>
      <Producer>Clif Family Winery</Producer>
      <Varietal>Cabernet Sauvignon</Varietal>
      <MasterVarietal>Cabernet Sauvignon</MasterVarietal>
      <Designation>Kit&#39;s Killer Cab</Designation>
      <Vineyard>Unknown</Vineyard>
      <Country>USA</Country>
      <Region>California</Region>
      <SubRegion>Napa Valley</SubRegion>
      <Appellation>Howell Mountain</Appellation>
      <PersonalBegin></PersonalBegin>
      <PersonalEnd></PersonalEnd>
      <ComBegin>2017</ComBegin>
      <ComEnd>2024</ComEnd>
      <BeginConsume>1/1/2017</BeginConsume>
      <EndConsume>12/31/2024</EndConsume>
      <Source>Community</Source>
    </row>
    <row>
      <iWine>2587207</iWine>
      <Type>Red</Type>
      <Color>Red</Color>
      <Category>Dry</Category>
      <Available>0.901735537190083</Available>
      <Linear>0.823348168435467</Linear>
      <Bell>0.901735537190083</Bell>
      <Early>0.930867768595041</Early>
      <Late>0.814504132231405</Late>
      <Fast>0.982933884297521</Fast>
      <TwinPeak>0.901735537190083</TwinPeak>
      <Simple>0.5</Simple>
      <Purchases>1</Purchases>
      <ActualPurchases>1</ActualPurchases>
      <Pending>0</Pending>
      <ActualPending>0</ActualPending>
      <LocalQuantityActual>1</LocalQuantityActual>
      <LocalQuantity>1</LocalQuantity>
      <Consumed>0</Consumed>
      <ActualConsumed>0</ActualConsumed>
      <Inventory>1</Inventory>
      <ActualInventory>1</ActualInventory>
      <Vintage>2014</Vintage>
      <Wine>Epoch Estate Wines Creativity</Wine>
      <SortWine>Epoch Estate Wines Creativity</SortWine>
      <Locale>USA, California, Central Coast, Paso Robles</Locale>
      <Producer>Epoch Estate Wines</Producer>
      <Varietal>Mourvèdre</Varietal>
      <MasterVarietal>Mourvèdre</MasterVarietal>
      <Designation>Creativity</Designation>
      <Vineyard>Unknown</Vineyard>
      <Country>USA</Country>
      <Region>California</Region>
      <SubRegion>Central Coast</SubRegion>
      <Appellation>Paso Robles</Appellation>
      <PersonalBegin></PersonalBegin>
      <PersonalEnd></PersonalEnd>
      <ComBegin>2017</ComBegin>
      <ComEnd>2024</ComEnd>
      <BeginConsume>1/1/2017</BeginConsume>
      <EndConsume>12/31/2024</EndConsume>
      <Source>Community</Source>
    </row>
    <row>
      <iWine>3927893</iWine>
      <Type>White - Sparkling</Type>
      <Color>White</Color>
      <Category>Sparkling</Category>
      <Available>0.862888482632541</Available>
      <Linear>0.862888482632541</Linear>
      <Bell>0.928333333333333</Bell>
      <Early>0.947833333333333</Early>
      <Late>0.877666666666667</Late>
      <Fast>0.988666666666667</Fast>
      <TwinPeak>0.928333333333333</TwinPeak>
      <Simple>1</Simple>
      <Purchases>1</Purchases>
      <ActualPurchases>1</ActualPurchases>
      <Pending>0</Pending>
      <ActualPending>0</ActualPending>
      <LocalQuantityActual>1</LocalQuantityActual>
      <LocalQuantity>1</LocalQuantity>
      <Consumed>0</Consumed>
      <ActualConsumed>0</ActualConsumed>
      <Inventory>1</Inventory>
      <ActualInventory>1</ActualInventory>
      <Vintage>2017</Vintage>
      <Wine>Iron Horse Vineyards Wedding Cuvée</Wine>
      <SortWine>Iron Horse Vineyards Wedding Cuvée</SortWine>
      <Locale>USA, California, Sonoma County, Green Valley of Russian River Valley</Locale>
      <Producer>Iron Horse Vineyards</Producer>
      <Varietal>Champagne Blend</Varietal>
      <MasterVarietal>Champagne Blend</MasterVarietal>
      <Designation>Wedding Cuvée</Designation>
      <Vineyard>Unknown</Vineyard>
      <Country>USA</Country>
      <Region>California</Region>
      <SubRegion>Sonoma County</SubRegion>
      <Appellation>Green Valley of Russian River Valley</Appellation>
      <PersonalBegin></PersonalBegin>
      <PersonalEnd></PersonalEnd>
      <ComBegin>2021</ComBegin>
      <ComEnd>2023</ComEnd>
      <BeginConsume>1/1/2021</BeginConsume>
      <EndConsume>12/31/2023</EndConsume>
      <Source>Community</Source>
    </row>
    <row>
      <iWine>4367782</iWine>
      <Type>White</Type>
      <Color>White</Color>
      <Category>Dry</Category>
      <Available>0.735222222222222</Available>
      <Linear>0.528767123287671</Linear>
      <Bell>0.542666666666667</Bell>
      <Early>0.735222222222222</Early>
      <Late>0.332333333333333</Late>
      <Fast>0.859555555555556</Fast>
      <TwinPeak>0.522666666666667</TwinPeak>
      <Simple>0.5</Simple>
      <Purchases>1</Purchases>
      <ActualPurchases>1</ActualPurchases>
      <Pending>0</Pending>
      <ActualPending>0</ActualPending>
      <LocalQuantityActual>1</LocalQuantityActual>
      <LocalQuantity>1</LocalQuantity>
      <Consumed>0</Consumed>
      <ActualConsumed>0</ActualConsumed>
      <Inventory>1</Inventory>
      <ActualInventory>1</ActualInventory>
      <Vintage>2021</Vintage>
      <Wine>Lioco Sauvignon Blanc Lolonis Vineyard</Wine>
      <SortWine>Lioco Sauvignon Blanc Lolonis Vineyard</SortWine>
      <Locale>USA, California, North Coast, Redwood Valley</Locale>
      <Producer>Lioco</Producer>
      <Varietal>Sauvignon Blanc</Varietal>
      <MasterVarietal>Sauvignon Blanc</MasterVarietal>
      <Designation>Unknown</Designation>
      <Vineyard>Lolonis Vineyard</Vineyard>
      <Country>USA</Country>
      <Region>California</Region>
      <SubRegion>North Coast</SubRegion>
      <Appellation>Redwood Valley</Appellation>
      <PersonalBegin></PersonalBegin>
      <PersonalEnd></PersonalEnd>
      <ComBegin>2022</ComBegin>
      <ComEnd>2024</ComEnd>
      <BeginConsume>1/1/2022</BeginConsume>
      <EndConsume>12/31/2024</EndConsume>
      <Source>Community</Source>
    </row>
    <row>
      <iWine>4250600</iWine>
      <Type>White</Type>
      <Color>White</Color>
      <Category>Dry</Category>
      <Available>0.722450331125828</Available>
      <Linear>0.517260273972603</Linear>
      <Bell>0.524635761589404</Bell>
      <Early>0.722450331125828</Early>
      <Late>0.316556291390728</Late>
      <Fast>0.851291390728477</Fast>
      <TwinPeak>0.504635761589404</TwinPeak>
      <Simple>0.333333333333333</Simple>
      <Purchases>1</Purchases>
      <ActualPurchases>1</ActualPurchases>
      <Pending>0</Pending>
      <ActualPending>0</ActualPending>
      <LocalQuantityActual>1</LocalQuantityActual>
      <LocalQuantity>1</LocalQuantity>
      <Consumed>0</Consumed>
      <ActualConsumed>0</ActualConsumed>
      <Inventory>1</Inventory>
      <ActualInventory>1</ActualInventory>
      <Vintage>2020</Vintage>
      <Wine>Abbot&#39;s Passage Noontide</Wine>
      <SortWine>Abbot&#39;s Passage Noontide</SortWine>
      <Locale>USA, California, Sonoma County, Sonoma Valley</Locale>
      <Producer>Abbot&#39;s Passage</Producer>
      <Varietal>White Blend</Varietal>
      <MasterVarietal>White Blend</MasterVarietal>
      <Designation>Noontide</Designation>
      <Vineyard>Unknown</Vineyard>
      <Country>USA</Country>
      <Region>California</Region>
      <SubRegion>Sonoma County</SubRegion>
      <Appellation>Sonoma Valley</Appellation>
      <PersonalBegin></PersonalBegin>
      <PersonalEnd></PersonalEnd>
      <ComBegin>2021</ComBegin>
      <ComEnd>2025</ComEnd>
      <BeginConsume>1/1/2021</BeginConsume>
      <EndConsume>12/31/2025</EndConsume>
      <Source>Community</Source>
    </row>
    <row>
      <iWine>3200359</iWine>
      <Type>White - Sparkling</Type>
      <Color>White</Color>
      <Category>Sparkling</Category>
      <Available>0.717415115005477</Available>
      <Linear>0.717415115005477</Linear>
      <Bell>0.79158940397351</Bell>
      <Early>0.877715231788079</Early>
      <Late>0.622384105960265</Late>
      <Fast>0.953476821192053</Fast>
      <TwinPeak>0.787748344370861</TwinPeak>
      <Simple>0.5</Simple>
      <Purchases>1</Purchases>
      <ActualPurchases>1</ActualPurchases>
      <Pending>0</Pending>
      <ActualPending>0</ActualPending>
      <LocalQuantityActual>1</LocalQuantityActual>
      <LocalQuantity>1</LocalQuantity>
      <Consumed>0</Consumed>
      <ActualConsumed>0</ActualConsumed>
      <Inventory>1</Inventory>
      <ActualInventory>1</ActualInventory>
      <Vintage>2014</Vintage>
      <Wine>Iron Horse Vineyards Chinese Cuvee</Wine>
      <SortWine>Iron Horse Vineyards Chinese Cuvee</SortWine>
      <Locale>USA, California, Sonoma County, Green Valley of Russian River Valley</Locale>
      <Producer>Iron Horse Vineyards</Producer>
      <Varietal>Champagne Blend</Varietal>
      <MasterVarietal>Champagne Blend</MasterVarietal>
      <Designation>Chinese Cuvee</Designation>
      <Vineyard>Unknown</Vineyard>
      <Country>USA</Country>
      <Region>California</Region>
      <SubRegion>Sonoma County</SubRegion>
      <Appellation>Green Valley of Russian River Valley</Appellation>
      <PersonalBegin></PersonalBegin>
      <PersonalEnd></PersonalEnd>
      <ComBegin>2020</ComBegin>
      <ComEnd>2024</ComEnd>
      <BeginConsume>1/1/2020</BeginConsume>
      <EndConsume>12/31/2024</EndConsume>
      <Source>Community</Source>
    </row>
    <row>
      <iWine>3404098</iWine>
      <Type>Red</Type>
      <Color>Red</Color>
      <Category>Dry</Category>
      <Available>0.524635761589404</Available>
      <Linear>0.517260273972603</Linear>
      <Bell>0.524635761589404</Bell>
      <Early>0.722450331125828</Early>
      <Late>0.316556291390728</Late>
      <Fast>0.851291390728477</Fast>
      <TwinPeak>0.504635761589404</TwinPeak>
      <Simple>0.333333333333333</Simple>
      <Purchases>1</Purchases>
      <ActualPurchases>1</ActualPurchases>
      <Pending>0</Pending>
      <ActualPending>0</ActualPending>
      <LocalQuantityActual>1</LocalQuantityActual>
      <LocalQuantity>1</LocalQuantity>
      <Consumed>0</Consumed>
      <ActualConsumed>0</ActualConsumed>
      <Inventory>1</Inventory>
      <ActualInventory>1</ActualInventory>
      <Vintage>2018</Vintage>
      <Wine>Vallone di Cecione Canaiolo</Wine>
      <SortWine>Vallone di Cecione Canaiolo</SortWine>
      <Locale>Italy, Tuscany, Toscana IGT</Locale>
      <Producer>Vallone di Cecione</Producer>
      <Varietal>Canaiolo</Varietal>
      <MasterVarietal>Canaiolo</MasterVarietal>
      <Designation>Unknown</Designation>
      <Vineyard>Unknown</Vineyard>
      <Country>Italy</Country>
      <Region>Tuscany</Region>
      <SubRegion>Unknown</SubRegion>
      <Appellation>Toscana IGT</Appellation>
      <PersonalBegin></PersonalBegin>
      <PersonalEnd></PersonalEnd>
      <ComBegin>2021</ComBegin>
      <ComEnd>2025</ComEnd>
      <BeginConsume>1/1/2021</BeginConsume>
      <EndConsume>12/31/2025</EndConsume>
      <Source>Community</Source>
    </row>
    <row>
      <iWine>4551812</iWine>
      <Type>Rosé</Type>
      <Color>Rosé</Color>
      <Category>Dry</Category>
      <Available>-0.534246575342466</Available>
      <Linear>-0.534246575342466</Linear>
      <Bell>-0.870338983050847</Bell>
      <Early>1.94915254237289E-02</Early>
      <Late>-1.34915254237288</Late>
      <Fast>1.15762711864407</Fast>
      <TwinPeak>-0.566101694915254</TwinPeak>
      <Simple>1.5</Simple>
      <Purchases>5</Purchases>
      <ActualPurchases>5</ActualPurchases>
      <Pending>0</Pending>
      <ActualPending>0</ActualPending>
      <LocalQuantityActual>3</LocalQuantityActual>
      <LocalQuantity>3</LocalQuantity>
      <Consumed>2</Consumed>
      <ActualConsumed>2</ActualConsumed>
      <Inventory>3</Inventory>
      <ActualInventory>3</ActualInventory>
      <Vintage>2022</Vintage>
      <Wine>Arnot-Roberts Rosé</Wine>
      <SortWine>Arnot-Roberts Rosé</SortWine>
      <Locale>USA, California</Locale>
      <Producer>Arnot-Roberts</Producer>
      <Varietal>Touriga Nacional</Varietal>
      <MasterVarietal>Touriga Nacional</MasterVarietal>
      <Designation>Rosé</Designation>
      <Vineyard>Unknown</Vineyard>
      <Country>USA</Country>
      <Region>California</Region>
      <SubRegion>Unknown</SubRegion>
      <Appellation>California</Appellation>
      <PersonalBegin></PersonalBegin>
      <PersonalEnd></PersonalEnd>
      <ComBegin>2023</ComBegin>
      <ComEnd>2024</ComEnd>
      <BeginConsume>1/1/2023</BeginConsume>
      <EndConsume>12/31/2024</EndConsume>
      <Source>Community</Source>
    </row>
  </availability>
</cellartracker>
"""

INVENTORY_TEST_DATA_XML = """
<cellartracker>
  <inventory>
    <row>
      <iWine>2630586</iWine>
      <Barcode>0170254219</Barcode>
      <Location>Library</Location>
      <Bin></Bin>
      <Size>750ml</Size>
      <Currency>USD</Currency>
      <ExchangeRate>1</ExchangeRate>
      <Valuation>0</Valuation>
      <Price>0</Price>
      <NativePrice>0</NativePrice>
      <NativePriceCurrency>USD</NativePriceCurrency>
      <StoreName>Unknown</StoreName>
      <PurchaseDate>12/4/2022</PurchaseDate>
      <BottleNote></BottleNote>
      <Vintage>2014</Vintage>
      <Wine>Clif Family Winery Cabernet Sauvignon Kit&#39;s Killer Cab</Wine>
      <Locale>USA, California, Napa Valley, Howell Mountain</Locale>
      <Country>USA</Country>
      <Region>California</Region>
      <SubRegion>Napa Valley</SubRegion>
      <Appellation>Howell Mountain</Appellation>
      <Producer>Clif Family Winery</Producer>
      <SortProducer>Clif Family Winery</SortProducer>
      <Type>Red</Type>
      <Color>Red</Color>
      <Category>Dry</Category>
      <Varietal>Cabernet Sauvignon</Varietal>
      <MasterVarietal>Cabernet Sauvignon</MasterVarietal>
      <Designation>Kit&#39;s Killer Cab</Designation>
      <Vineyard>Unknown</Vineyard>
      <CT>91.1666666666667</CT>
      <CNotes>6</CNotes>
      <MY></MY>
      <PNotes></PNotes>
      <BeginConsume>2017</BeginConsume>
      <EndConsume>2024</EndConsume>
      <PurchasedCommunity>307</PurchasedCommunity>
      <QuantityCommunity>145</QuantityCommunity>
      <PendingCommunity>0</PendingCommunity>
      <ConsumedCommunity>162</ConsumedCommunity>
    </row>
    <row>
      <iWine>2587207</iWine>
      <Barcode>0170254355</Barcode>
      <Location>Library</Location>
      <Bin></Bin>
      <Size>750ml</Size>
      <Currency>USD</Currency>
      <ExchangeRate>1</ExchangeRate>
      <Valuation>0</Valuation>
      <Price>0</Price>
      <NativePrice>0</NativePrice>
      <NativePriceCurrency>USD</NativePriceCurrency>
      <StoreName>Unknown</StoreName>
      <PurchaseDate>12/4/2022</PurchaseDate>
      <BottleNote>Anniversary 2024</BottleNote>
      <Vintage>2014</Vintage>
      <Wine>Epoch Estate Wines Creativity</Wine>
      <Locale>USA, California, Central Coast, Paso Robles</Locale>
      <Country>USA</Country>
      <Region>California</Region>
      <SubRegion>Central Coast</SubRegion>
      <Appellation>Paso Robles</Appellation>
      <Producer>Epoch Estate Wines</Producer>
      <SortProducer>Epoch Estate Wines</SortProducer>
      <Type>Red</Type>
      <Color>Red</Color>
      <Category>Dry</Category>
      <Varietal>Mourvèdre</Varietal>
      <MasterVarietal>Mourvèdre</MasterVarietal>
      <Designation>Creativity</Designation>
      <Vineyard>Unknown</Vineyard>
      <CT>92.8</CT>
      <CNotes>21</CNotes>
      <MY></MY>
      <PNotes></PNotes>
      <BeginConsume>2017</BeginConsume>
      <EndConsume>2024</EndConsume>
      <PurchasedCommunity>305</PurchasedCommunity>
      <QuantityCommunity>127</QuantityCommunity>
      <PendingCommunity>0</PendingCommunity>
      <ConsumedCommunity>178</ConsumedCommunity>
    </row>
    <row>
      <iWine>3927893</iWine>
      <Barcode>0170254643</Barcode>
      <Location>Library</Location>
      <Bin></Bin>
      <Size>750ml</Size>
      <Currency>USD</Currency>
      <ExchangeRate>1</ExchangeRate>
      <Valuation>0</Valuation>
      <Price>0</Price>
      <NativePrice>0</NativePrice>
      <NativePriceCurrency>USD</NativePriceCurrency>
      <StoreName>Unknown</StoreName>
      <PurchaseDate>12/4/2022</PurchaseDate>
      <BottleNote></BottleNote>
      <Vintage>2017</Vintage>
      <Wine>Iron Horse Vineyards Wedding Cuvée</Wine>
      <Locale>USA, California, Sonoma County, Green Valley of Russian River Valley</Locale>
      <Country>USA</Country>
      <Region>California</Region>
      <SubRegion>Sonoma County</SubRegion>
      <Appellation>Green Valley of Russian River Valley</Appellation>
      <Producer>Iron Horse Vineyards</Producer>
      <SortProducer>Iron Horse Vineyards</SortProducer>
      <Type>White - Sparkling</Type>
      <Color>White</Color>
      <Category>Sparkling</Category>
      <Varietal>Champagne Blend</Varietal>
      <MasterVarietal>Champagne Blend</MasterVarietal>
      <Designation>Wedding Cuvée</Designation>
      <Vineyard>Unknown</Vineyard>
      <CT>90.6666666666667</CT>
      <CNotes>10</CNotes>
      <MY></MY>
      <PNotes></PNotes>
      <BeginConsume>2021</BeginConsume>
      <EndConsume>2023</EndConsume>
      <PurchasedCommunity>401</PurchasedCommunity>
      <QuantityCommunity>205</QuantityCommunity>
      <PendingCommunity>0</PendingCommunity>
      <ConsumedCommunity>196</ConsumedCommunity>
    </row>
    <row>
      <iWine>4367782</iWine>
      <Barcode>0173673931</Barcode>
      <Location>Cellar</Location>
      <Bin>Right rack</Bin>
      <Size>750ml</Size>
      <Currency>USD</Currency>
      <ExchangeRate>1</ExchangeRate>
      <Valuation>0</Valuation>
      <Price>0</Price>
      <NativePrice>0</NativePrice>
      <NativePriceCurrency>USD</NativePriceCurrency>
      <StoreName>Unknown</StoreName>
      <PurchaseDate>2/27/2023</PurchaseDate>
      <BottleNote></BottleNote>
      <Vintage>2021</Vintage>
      <Wine>Lioco Sauvignon Blanc Lolonis Vineyard</Wine>
      <Locale>USA, California, North Coast, Redwood Valley</Locale>
      <Country>USA</Country>
      <Region>California</Region>
      <SubRegion>North Coast</SubRegion>
      <Appellation>Redwood Valley</Appellation>
      <Producer>Lioco</Producer>
      <SortProducer>Lioco</SortProducer>
      <Type>White</Type>
      <Color>White</Color>
      <Category>Dry</Category>
      <Varietal>Sauvignon Blanc</Varietal>
      <MasterVarietal>Sauvignon Blanc</MasterVarietal>
      <Designation>Unknown</Designation>
      <Vineyard>Lolonis Vineyard</Vineyard>
      <CT>90</CT>
      <CNotes>1</CNotes>
      <MY></MY>
      <PNotes></PNotes>
      <BeginConsume>2022</BeginConsume>
      <EndConsume>2024</EndConsume>
      <PurchasedCommunity>52</PurchasedCommunity>
      <QuantityCommunity>24</QuantityCommunity>
      <PendingCommunity>0</PendingCommunity>
      <ConsumedCommunity>28</ConsumedCommunity>
    </row>
    <row>
      <iWine>4250600</iWine>
      <Barcode>0170253600</Barcode>
      <Location>Cellar</Location>
      <Bin>Right rack</Bin>
      <Size>750ml</Size>
      <Currency>USD</Currency>
      <ExchangeRate>1</ExchangeRate>
      <Valuation>0</Valuation>
      <Price>0</Price>
      <NativePrice>0</NativePrice>
      <NativePriceCurrency>USD</NativePriceCurrency>
      <StoreName>Unknown</StoreName>
      <PurchaseDate>12/4/2022</PurchaseDate>
      <BottleNote></BottleNote>
      <Vintage>2020</Vintage>
      <Wine>Abbot&#39;s Passage Noontide</Wine>
      <Locale>USA, California, Sonoma County, Sonoma Valley</Locale>
      <Country>USA</Country>
      <Region>California</Region>
      <SubRegion>Sonoma County</SubRegion>
      <Appellation>Sonoma Valley</Appellation>
      <Producer>Abbot&#39;s Passage</Producer>
      <SortProducer>Abbot&#39;s Passage</SortProducer>
      <Type>White</Type>
      <Color>White</Color>
      <Category>Dry</Category>
      <Varietal>White Blend</Varietal>
      <MasterVarietal>White Blend</MasterVarietal>
      <Designation>Noontide</Designation>
      <Vineyard>Unknown</Vineyard>
      <CNotes>0</CNotes>
      <MY></MY>
      <PNotes></PNotes>
      <BeginConsume>2021</BeginConsume>
      <EndConsume>2025</EndConsume>
      <PurchasedCommunity>35</PurchasedCommunity>
      <QuantityCommunity>16</QuantityCommunity>
      <PendingCommunity>0</PendingCommunity>
      <ConsumedCommunity>19</ConsumedCommunity>
    </row>
    <row>
      <iWine>3200359</iWine>
      <Barcode>0170254639</Barcode>
      <Location>Library</Location>
      <Bin></Bin>
      <Size>750ml</Size>
      <Currency>USD</Currency>
      <ExchangeRate>1</ExchangeRate>
      <Valuation>0</Valuation>
      <Price>0</Price>
      <NativePrice>0</NativePrice>
      <NativePriceCurrency>USD</NativePriceCurrency>
      <StoreName>Unknown</StoreName>
      <PurchaseDate>12/4/2022</PurchaseDate>
      <BottleNote></BottleNote>
      <Vintage>2014</Vintage>
      <Wine>Iron Horse Vineyards Chinese Cuvee</Wine>
      <Locale>USA, California, Sonoma County, Green Valley of Russian River Valley</Locale>
      <Country>USA</Country>
      <Region>California</Region>
      <SubRegion>Sonoma County</SubRegion>
      <Appellation>Green Valley of Russian River Valley</Appellation>
      <Producer>Iron Horse Vineyards</Producer>
      <SortProducer>Iron Horse Vineyards</SortProducer>
      <Type>White - Sparkling</Type>
      <Color>White</Color>
      <Category>Sparkling</Category>
      <Varietal>Champagne Blend</Varietal>
      <MasterVarietal>Champagne Blend</MasterVarietal>
      <Designation>Chinese Cuvee</Designation>
      <Vineyard>Unknown</Vineyard>
      <CT>91.8571428571429</CT>
      <CNotes>7</CNotes>
      <MY></MY>
      <PNotes></PNotes>
      <BeginConsume>2020</BeginConsume>
      <EndConsume>2024</EndConsume>
      <PurchasedCommunity>286</PurchasedCommunity>
      <QuantityCommunity>100</QuantityCommunity>
      <PendingCommunity>0</PendingCommunity>
      <ConsumedCommunity>186</ConsumedCommunity>
    </row>
    <row>
      <iWine>3404098</iWine>
      <Barcode>0177692955</Barcode>
      <Location>Library</Location>
      <Bin></Bin>
      <Size>750ml</Size>
      <Currency>USD</Currency>
      <ExchangeRate>1</ExchangeRate>
      <Valuation>0</Valuation>
      <Price>0</Price>
      <NativePrice>0</NativePrice>
      <NativePriceCurrency>USD</NativePriceCurrency>
      <StoreName>Unknown</StoreName>
      <PurchaseDate>6/3/2023</PurchaseDate>
      <BottleNote></BottleNote>
      <Vintage>2018</Vintage>
      <Wine>Vallone di Cecione Canaiolo</Wine>
      <Locale>Italy, Tuscany, Toscana IGT</Locale>
      <Country>Italy</Country>
      <Region>Tuscany</Region>
      <SubRegion>Unknown</SubRegion>
      <Appellation>Toscana IGT</Appellation>
      <Producer>Vallone di Cecione</Producer>
      <SortProducer>Vallone di Cecione</SortProducer>
      <Type>Red</Type>
      <Color>Red</Color>
      <Category>Dry</Category>
      <Varietal>Canaiolo</Varietal>
      <MasterVarietal>Canaiolo</MasterVarietal>
      <Designation>Unknown</Designation>
      <Vineyard>Unknown</Vineyard>
      <CNotes>0</CNotes>
      <MY></MY>
      <PNotes></PNotes>
      <BeginConsume>2021</BeginConsume>
      <EndConsume>2025</EndConsume>
      <PurchasedCommunity>6</PurchasedCommunity>
      <QuantityCommunity>4</QuantityCommunity>
      <PendingCommunity>0</PendingCommunity>
      <ConsumedCommunity>2</ConsumedCommunity>
    </row>
    <row>
      <iWine>4551812</iWine>
      <Barcode>0173674184</Barcode>
      <Location>Cellar</Location>
      <Bin></Bin>
      <Size>750ml</Size>
      <Currency>USD</Currency>
      <ExchangeRate>1</ExchangeRate>
      <Valuation>0</Valuation>
      <Price>0</Price>
      <NativePrice>0</NativePrice>
      <NativePriceCurrency>USD</NativePriceCurrency>
      <StoreName>Unknown</StoreName>
      <PurchaseDate>2/27/2023</PurchaseDate>
      <BottleNote></BottleNote>
      <Vintage>2022</Vintage>
      <Wine>Arnot-Roberts Rosé</Wine>
      <Locale>USA, California</Locale>
      <Country>USA</Country>
      <Region>California</Region>
      <SubRegion>Unknown</SubRegion>
      <Appellation>California</Appellation>
      <Producer>Arnot-Roberts</Producer>
      <SortProducer>Arnot-Roberts</SortProducer>
      <Type>Rosé</Type>
      <Color>Rosé</Color>
      <Category>Dry</Category>
      <Varietal>Touriga Nacional</Varietal>
      <MasterVarietal>Touriga Nacional</MasterVarietal>
      <Designation>Rosé</Designation>
      <Vineyard>Unknown</Vineyard>
      <CNotes>17</CNotes>
      <MY></MY>
      <PNotes></PNotes>
      <BeginConsume>2023</BeginConsume>
      <EndConsume>2024</EndConsume>
      <PurchasedCommunity>664</PurchasedCommunity>
      <QuantityCommunity>417</QuantityCommunity>
      <PendingCommunity>31</PendingCommunity>
      <ConsumedCommunity>216</ConsumedCommunity>
    </row>
  </inventory>
</cellartracker>
"""

CACHE_TTL_SECONDS = 600

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
#       "title": "oathbreaker",
#       "description": "cool fantasy book",
#       "price": "20.00"
#     },
#     {
#       "title": "rhythm of war",
#       "description": "another cool fantasy book",
#       "price": "25.00"
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
def get_inventory_csv(username, password):
    url = "https://www.cellartracker.com/xlquery.asp?User=%s&Password=%s&Format=csv&Table=Inventory" % (username, password)
    resp = http.get(url, ttl_seconds = CACHE_TTL_SECONDS)
    return resp.body()

# Get availability report which is sorted by ready to drink
def get_availability_csv(username, password):
    url = "https://www.cellartracker.com/xlquery.asp?User=%s&Password=%s&Format=csv&Table=Availability" % (username, password)
    resp = http.get(url, ttl_seconds = CACHE_TTL_SECONDS)
    return resp.body()

def inventory_xml_to_dict_list(raw_xml_string):
    result = []
    rows = xpath.loads(raw_xml_string).query_all_nodes("/cellartracker/inventory/row")
    for row in rows:
        dict_row = {}
        dict_row["iWine"] = row.query("/iWine")
        dict_row["BottleNote"] = row.query("/BottleNote")
        result.append(dict_row)
    return result

def availability_xml_to_dict_list(raw_xml_string):
    result = []
    rows = xpath.loads(raw_xml_string).query_all_nodes("/cellartracker/availability/row")
    for row in rows:
        dict_row = {}
        dict_row["iWine"] = row.query("/iWine")
        dict_row["Type"] = row.query("/Type")
        dict_row["Category"] = row.query("/Category")
        dict_row["Vintage"] = row.query("/Vintage")
        dict_row["Producer"] = row.query("/Producer")
        dict_row["Designation"] = row.query("/Designation")
        dict_row["Varietal"] = row.query("/Varietal")
        result.append(dict_row)
    return result

# Get inventory report which includes private notes
# that we can use for filtering out excluded bottles
def get_inventory_xml(username, password):
    url = "https://www.cellartracker.com/xlquery.asp?User=%s&Password=%s&Format=xml&Table=Inventory" % (username, password)
    resp = http.get(url, ttl_seconds = CACHE_TTL_SECONDS)
    return resp.body()

# Get availability report which is sorted by ready to drink
def get_availability_xml(username, password):
    url = "https://www.cellartracker.com/xlquery.asp?User=%s&Password=%s&Format=xml&Table=Availability" % (username, password)
    resp = http.get(url, ttl_seconds = CACHE_TTL_SECONDS)
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

# TODO - consider removing this if XML export works reliably and we can remove
# the csv export functions
#
# Unfortunately, Starlark doesn't have encoding/decoding functions for
# strings or bytes. Even more unfortunately, CellarTracker returns strings
# encoded in latin1/ISO-8859-1, and Starlark is unable to convert those
# into UTF-8, so what should be "Cuvée" comes through as "Cuv\xe9e".
#
# Here we will fix specific characters known to be problematic, with
# the hope that eventually Starlark will add bytes encoding+decoding
# and we can solve this more cleanly.
def fix_wine_display_name(display_name):
    # Use repr() to convert the invalid characters to hex encoded literals, and
    # then trim off the double quotes
    name = repr(display_name)[1:-1]
    name = name.replace("\\xe9", "é")
    name = name.replace("\\xe8", "è")
    name = name.replace("\\xed", "í")
    name = name.replace("\\xf3", "ó")
    return name

# Use this command to generate base64 data of the image files
#
# python -c 'import base64; print(base64.b64encode(open("images/white-wine-glass.png", "rb").read()).decode("utf-8"))'
#
def get_wine_glass_image_data(wine_type):
    if wine_type == "White":
        return "iVBORw0KGgoAAAANSUhEUgAAAAoAAAAWCAYAAAD5Jg1dAAAAAXNSR0IArs4c6QAAAH1JREFUOE9jPPvi138GIgAjSKGROCtepede/mYYfgr12boZmAWrGP6+b8Pw/ZMHVxjeSi2E+Jo2CnGFOIbV1FMIMgnmIXRTYdYaS7AxMsIkQYqFn8WjqAUFC0gRSBCuEGYyTDGyIgyFMMUgGmYSzAoUEwdIIa68A/c1sZkLAHHel5t001MXAAAAAElFTkSuQmCC"
    elif wine_type == "Sparkling":
        return "iVBORw0KGgoAAAANSUhEUgAAAAkAAAAWCAYAAAASEbZeAAAAAXNSR0IArs4c6QAAAJtJREFUOE9jZGBgYDj74td/EI0NGEuwMTLCFBmJs2KoOffyNwPxikBWYTMFZizINMYBUKTP1o3V+08eXGF4K7UQ4iaQImbBKoa/79vgikH8h+ejUBXBZJEVY5iEzb6Bsg4WwejBAHMPPIJhCoWfxcPdDwofkAKQAJiAAVCYgRQiK8BQBDMRZgJMM4pJ1FOEnNaRrQRHMK5MABMHACiPoD+N8QF/AAAAAElFTkSuQmCC"
    elif wine_type == "Rosé"
        return "iVBORw0KGgoAAAANSUhEUgAAAAoAAAAWCAYAAAD5Jg1dAAAAAXNSR0IArs4c6QAAAIFJREFUOE9jPPvi138GIgAjSKGROCtepede/mYYfgr1O1YzMPdHMfwtXIbh+8/7DjPc2zUJ4mvaKMQV4hhWU08hyCSYh9BNhVlrLMHGyAiTBClWcstDUQsKFpAikCBcIcxkmGJkRRgKYYpBNMwkmBUoJg6gQvT8g+xOsBsJZTCQBgBCkp7t6fyTqwAAAABJRU5ErkJggg=="
    else:  # Red is the default
        return "iVBORw0KGgoAAAANSUhEUgAAAAoAAAAWCAYAAAD5Jg1dAAAAAXNSR0IArs4c6QAAAIFJREFUOE9jPPvi138GIgAjSKGROCtepede/mYYfgp5g60ZVI+cYrhtY4bh+80fPjE47L0M8TVtFOIKcQyrqacQZBLMQ+imwqw1lmBjZIRJghQfcNZFUQsKFpAikCBcIcxkmGJkRRgKYYpBNMwkmBUoJg6gQvT8g+xOsBsJZTCQBgA6R5ftTBH+3wAAAABJRU5ErkJggg=="

def main(config):
    # raw_inventory_csv = INVENTORY_TEST_DATA_CSV
    # raw_availability_csv = AVAILABILITY_TEST_DATA_CSV
    raw_inventory_xml = INVENTORY_TEST_DATA_XML
    raw_availability_xml = AVAILABILITY_TEST_DATA_XML

    username = config.get("cellartracker_username")
    password = config.get("cellartracker_password")

    if username and password:
        print("CellarTracker credentials found, fetching data from server")

        # raw_inventory_csv = get_inventory_csv(username, password)
        # raw_availability_csv = get_availability_csv(username, password)
        raw_inventory_xml = get_inventory_xml(username, password)
        raw_availability_xml = get_availability_xml(username, password)
    else:
        print("No CellarTracker credentials found, defaulting to test data")

    # inventory_list = csv_to_dict_list(raw_inventory_csv)
    # availability_list = csv_to_dict_list(raw_availability_csv)
    inventory_list = inventory_xml_to_dict_list(raw_inventory_xml)
    availability_list = availability_xml_to_dict_list(raw_availability_xml)

    excluded_wine_ids = select_excluded_wine_ids(inventory_list)

    # Pick a random wine type
    wine_types = ["Red", "White", "Sparkling"]
    idx = random.number(0, len(wine_types) - 1)
    wine_type_to_display = wine_types[idx]

    bottle = find_bottle_to_display(wine_type_to_display, availability_list, excluded_wine_ids)
    wine_glass_image = get_wine_glass_image_data(wine_type_to_display)
    wine_display_name = fix_wine_display_name(wine_display_text(bottle))

    return render.Root(
        child = render.Row(
            expanded = True,
            main_align = "start",
            cross_align = "center",
            children = [
                render.Box(
                    width = 14,
                    child = render.Image(
                        src = base64.decode(wine_glass_image),
                    ),
                ),
                render.Marquee(
                    scroll_direction = "vertical",
                    height = 32,
                    offset_start = 30,
                    offset_end = 30,
                    align = "center",
                    child = render.WrappedText(
                        width = 50,
                        content = wine_display_name,
                        color = "#afafaf",
                    ),
                ),
            ],
        ),
    )
