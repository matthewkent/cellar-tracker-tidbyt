load("encoding/base64.star", "base64")
load("encoding/csv.star", "csv")
load("http.star", "http")
load("random.star", "random")
load("render.star", "render")
load("schema.star", "schema")
load("xpath.star", "xpath")

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
      <BottleNote>Matt Birthday 2024</BottleNote>
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

DEFAULT_TOP_N_VALUE = 10

WHITE_WINE_GLASS_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAoAAAAWCAYAAAD5Jg1dAAAAAXNSR0IArs4c6QAAAH1JREFUOE9jPPvi138GIgAjS
KGROCtepede/mYYfgr12boZmAWrGP6+b8Pw/ZMHVxjeSi2E+Jo2CnGFOIbV1FMIMgnmIXRTYdYaS7AxMsIkQYqFn8
WjqAUFC0gRSBCuEGYyTDGyIgyFMMUgGmYSzAoUEwdIIa68A/c1sZkLAHHel5t001MXAAAAAElFTkSuQmCC
""")

SPARKLING_WINE_GLASS_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAkAAAAWCAYAAAASEbZeAAAAAXNSR0IArs4c6QAAAJtJREFUOE9jZGBgYDj74td/E
I0NGEuwMTLCFBmJs2KoOffyNwPxikBWYTMFZizINMYBUKTP1o3V+08eXGF4K7UQ4iaQImbBKoa/79vgikH8h+ejUB
XBZJEVY5iEzb6Bsg4WwejBAHMPPIJhCoWfxcPdDwofkAKQAJiAAVCYgRQiK8BQBDMRZgJMM4pJ1FOEnNaRrQRHMK5
MABMHACiPoD+N8QF/AAAAAElFTkSuQmCC
""")

ROSE_WINE_GLASS_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAoAAAAWCAYAAAD5Jg1dAAAAAXNSR0IArs4c6QAAAIFJREFUOE9jPPvi138GIgAjS
KGROCtepede/mYYfgr1O1YzMPdHMfwtXIbh+8/7DjPc2zUJ4mvaKMQV4hhWU08hyCSYh9BNhVlrLMHGyAiTBClWcs
tDUQsKFpAikCBcIcxkmGJkRRgKYYpBNMwkmBUoJg6gQvT8g+xOsBsJZTCQBgBCkp7t6fyTqwAAAABJRU5ErkJggg==
""")

RED_WINE_GLASS_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAoAAAAWCAYAAAD5Jg1dAAAAAXNSR0IArs4c6QAAAIFJREFUOE9jPPvi138GIgAjS
KGROCtepede/mYYfgp5g60ZVI+cYrhtY4bh+80fPjE47L0M8TVtFOIKcQyrqacQZBLMQ+imwqw1lmBjZIRJghQfcN
ZFUQsKFpAikCBcIcxkmGJkRRgKYYpBNMwkmBUoJg6gQvT8g+xOsBsJZTCQBgA6R5ftTBH+3wAAAABJRU5ErkJggg==
""")

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
        dict_row["Wine"] = row.query("/Wine")
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
    if resp.status_code != 200:
        fail("API request failed with status %d", resp.status_code)
    return resp.body()

# Get availability report which is sorted by ready to drink
def get_availability_xml(username, password):
    url = "https://www.cellartracker.com/xlquery.asp?User=%s&Password=%s&Format=xml&Table=Availability" % (username, password)
    resp = http.get(url, ttl_seconds = CACHE_TTL_SECONDS)
    if resp.status_code != 200:
        fail("API request failed with status %d", resp.status_code)
    return resp.body()

# Return a list of iWine ids for bottles to be excluded from the availability report
def select_excluded_wine_ids(inventory_list, exclusion_keyword_list):
    excluded_wine_ids = []
    for bottle in inventory_list:
        for keyword in exclusion_keyword_list:
            if keyword in bottle["BottleNote"]:
                excluded_wine_ids.append(bottle["iWine"])
    return excluded_wine_ids

def wine_display_text(bottle):
    display_text_components = [bottle["Vintage"], bottle["Wine"]]
    return " ".join(display_text_components)

# Use this command to generate base64 data of the image files
#
# python -c 'import base64; print(base64.b64encode(open("images/white-wine-glass.png", "rb").read()).decode("utf-8"))'
#
def get_wine_glass_icon(bottle):
    wine_type = bottle["Type"]
    if wine_type == "White":
        return WHITE_WINE_GLASS_ICON
    elif wine_type.endswith("Sparkling"):
        # CellarTracker has "Red - Sparkling", "White - Sparkling" etc but we only have one sparkling icon
        return SPARKLING_WINE_GLASS_ICON
    elif wine_type == "Rosé":
        return ROSE_WINE_GLASS_ICON
    else:  
        return RED_WINE_GLASS_ICON

def select_displayable_bottles(availability_list, excluded_wine_ids):
    displayable_bottles = []
    for bottle in availability_list:
        bottle_id = bottle["iWine"]
        if bottle_id not in excluded_wine_ids:
            displayable_bottles.append(bottle)
    return displayable_bottles

def select_bottle_to_display(top_n_value, displayable_bottles):
    top_n_length = min(top_n_value, len(displayable_bottles))
    top_n_bottles = displayable_bottles[0:top_n_length]
    idx = random.number(0, len(top_n_bottles) - 1)
    return top_n_bottles[idx]

def main(config):
    username = config.get("cellartracker_username")
    password = config.get("cellartracker_password")
    exclusion_keywords_string = config.get("exclusion_keywords")
    top_n_value = int(config.get("top_n_value") or DEFAULT_TOP_N_VALUE)

    # These options are not exposed in the schema and are only
    # intended to be used in development
    use_test_data = config.get("use_test_data")
    bottle_id_override = config.get("bottle_id")

    exclusion_keyword_list = []
    if exclusion_keywords_string:
        exclusion_keyword_list = exclusion_keywords_string.split(",")

    if username and password:
        print("CellarTracker credentials found, fetching data from server")

        raw_inventory_xml = get_inventory_xml(username, password)
        raw_availability_xml = get_availability_xml(username, password)
    elif use_test_data:
        print("Using hardcoded test data")

        raw_inventory_xml = INVENTORY_TEST_DATA_XML
        raw_availability_xml = AVAILABILITY_TEST_DATA_XML
    else:
        print("No CellarTracker credentials found")

        return render.Root(
            render.WrappedText(
                width = 64,
                content = "CellarTracker credentials missing",
                color = "#afafaf",
            )
        )

    inventory_list = inventory_xml_to_dict_list(raw_inventory_xml)
    availability_list = availability_xml_to_dict_list(raw_availability_xml)

    excluded_wine_ids = select_excluded_wine_ids(inventory_list, exclusion_keyword_list)
    displayable_bottles = select_displayable_bottles(availability_list, excluded_wine_ids)

    bottle = select_bottle_to_display(top_n_value, displayable_bottles)

    if bottle_id_override:
        bottle = [b for b in availability_list if b["iWine"] == bottle_id_override][0]

    wine_glass_icon = get_wine_glass_icon(bottle)
    wine_display_name = wine_display_text(bottle)

    return render.Root(
        child = render.Row(
            expanded = True,
            main_align = "start",
            cross_align = "center",
            children = [
                render.Box(
                    width = 14,
                    child = render.Image(
                        src = wine_glass_icon,
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

def get_schema():
    return schema.Schema(
        version = "1",
        fields = [
            schema.Text(
                id = "cellartracker_username",
                name = "CellarTracker username",
                desc = "CellarTracker username",
                icon = "user",
            ),
            schema.Text(
                id = "cellartracker_password",
                name = "CellarTracker password",
                desc = "CellarTracker password",
                icon = "key",
            ),
            schema.Text(
                id = "exclusion_keywords",
                name = "Exclusion keywords",
                desc = "Comma-separated list of keywords. If any keyword is found in the BottleNote then the wine is excluded from display.",
                icon = "ban",
            ),
            schema.Text(
                id = "top_n_value",
                name = "Top N bottles",
                desc = "This app displays a random bottle from the top N bottles of the ready-to-drink report. Set N to a larger number if you want more variety in the results displayed or if you have a lot of bottles in your cellar that will be ready to drink soon.",
                icon = "wineBottle",
                default = "10",
            ),
        ]
    )
