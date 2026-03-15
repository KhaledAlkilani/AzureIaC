# Teoriakysymykset -- Azure IaC ja Bicep

Vastaa seuraaviin kysymyksiin omin sanoin. Vastausten ei tarvitse olla pitkiä -- muutama lause riittää, kunhan osoitat ymmärryksesi.

---

## Osa 1: Infrastructure as Code

### Kysymys 1: IaC:n perusidea

Selitä omin sanoin, mitä Infrastructure as Code tarkoittaa ja miksi sitä käytetään. Anna esimerkki tilanteesta, jossa IaC on hyödyllisempi kuin resurssien luominen käsin Azure Portalissa.

_Infrastructure as Code tarkoittaa, että palvelimet ja muut resurssit luodaan koodilla, ei käsin. Esimerkiksi jos pitää luoda sama ympäristö uudelleen, koodi tekee sen automaattisesti — ei tarvitse klikata Azure Portalissa joka kerta uudestaan._

### Kysymys 2: Deklaratiivinen vs. imperatiivinen

Selitä ero deklaratiivisen ja imperatiivisen IaC-lähestymistavan välillä. Kumpaan kategoriaan Bicep kuuluu?

_Imperatiivinen tarkoittaa, että kerrot vaihe vaiheelta mitä tehdään: "luo ensin tämä, sitten tuo". Deklaratiivinen tarkoittaa, että kerrot vain lopputuloksen: "haluan nämä resurssit". Bicep on deklaratiivinen._

### Kysymys 3: Idempotenssi

Mitä tarkoittaa, kun sanotaan, että IaC on **idempotenttia**? Miksi tämä ominaisuus on hyödyllinen?

_Idempotentti tarkoittaa, että voit ajaa saman koodin monta kertaa ja lopputulos on aina sama. Jos resurssi on jo olemassa, sitä ei luoda uudelleen. Tämä on hyödyllistä, koska ei tarvitse pelätä virheiden syntymistä jos ajaa koodin vahingossa kahdesti._

### Kysymys 4: Konfiguraation ajautuminen (drift)

Selitä, mitä "configuration drift" tarkoittaa. Miten IaC auttaa estämään sitä?

_Configuration drift tarkoittaa, että joku muuttaa resursseja käsin Portalissa, jolloin ne eivät enää vastaa koodia. IaC estää tämän, koska ympäristö voidaan aina palauttaa oikeaan tilaan ajamalla koodi uudelleen._

---

## Osa 2: Bicep

### Kysymys 5: Bicep vs. ARM

Miksi Bicep kehitettiin ARM JSON -templatejen tilalle? Mainitse vähintään 2 etua.

_ARM JSON on vaikealukuista ja pitkää. Bicep kehitettiin koska se on lyhyempää ja helpommin luettavaa. Bicep myös tarkistaa virheet ennen deploymenttia, mitä ARM ei tee yhtä hyvin._

### Kysymys 6: Parametrit ja `@secure()`

Miksi tietokantasalasana merkitään `@secure()`-dekoraattorilla Bicepissä? Mitä tapahtuisi ilman sitä?

_@secure() estää salasanan näkymisen logeissa ja deployment-historiassa. Ilman sitä salasana näkyisi selväkielisenä Azure Portalissa, mikä on tietoturvariski._

### Kysymys 7: Moduulit

Miksi infrastruktuurikoodi jaettiin tässä tehtävässä kolmeen erilliseen moduuliin (`acr.bicep`, `postgresql.bicep`, `appservice.bicep`) yhden ison tiedoston sijaan? Mainitse vähintään 2 syytä.

_Koodi jaettiin moduuleihin koska jokainen tiedosto on pienempi ja helpompi ymmärtää. Lisäksi moduuleja voi käyttää uudelleen muissa projekteissa — esimerkiksi postgresql.bicep voi toimia myös toisessa sovelluksessa._

### Kysymys 8: `uniqueString()`

Miksi ACR:n ja PostgreSQL-palvelimen nimissä käytetään `uniqueString(resourceGroup().id)` -funktiota? Mitä tapahtuisi ilman sitä?

_uniqueString() Azure-resurssien nimien täytyy olla globaalisti uniikkeja. uniqueString() luo automaattisesti uniikin päätteen nimeen. Ilman sitä deployment epäonnistuisi, jos joku muu on jo käyttänyt saman nimen._

### Kysymys 9: `targetScope`

Mitä tarkoittaa `targetScope = 'subscription'` main.bicep-tiedostossa? Miksi emme käytä oletusarvoa `resourceGroup`?

_targetScope = 'subscription' tarkoittaa, että deployment tehdään koko subscriptionin tasolla. Tämä tarvitaan koska resource group luodaan Bicepissä — oletusarvo resourceGroup vaatisi, että resource group on jo olemassa._

---

## Osa 3: Azure-resurssit

### Kysymys 10: Resource Group

Mikä on Azure Resource Groupin tarkoitus? Miksi kaikki sovelluksen resurssit kannattaa sijoittaa samaan resource groupiin?

_Resource Group on kansio, johon kaikki sovelluksen resurssit sijoitetaan. Kun kaikki resurssit ovat samassa ryhmässä, ne on helppo hallita, seurata kustannuksia ja poistaa kerralla._

### Kysymys 11: Ympäristömuuttujat ja Connection String

Selitä, miten sovelluksen tietokantayhteys konfiguroidaan eri ympäristöissä:

- Miten connection string asetetaan **Docker Composessa** (lokaalissa kehityksessä)?
- Miten **sama** connection string asetetaan **Azure App Servicessä**?
- Miksi sovelluksen koodi ei muutu, vaikka ympäristö vaihtuu?

_Docker Composessa connection string asetetaan .env-tiedostossa muuttujana ConnectionStrings\_\_DefaultConnection. Azure App Servicessä sama muuttuja asetetaan App Servicen asetuksissa. Sovelluksen koodi lukee aina saman muuttujan nimeltä, se ei tiedä eikä välitä mistä arvo tulee, joten koodi ei muutu._

### Kysymys 13: PostgreSQL Flexible Server -- Firewall

Miksi PostgreSQL-palvelimeen luodaan firewall-sääntö `AllowAzureServices` (IP-alue `0.0.0.0 - 0.0.0.0`)? Mitä tapahtuisi ilman sitä?

_Sääntö 0.0.0.0 - 0.0.0.0 sallii yhteydet muista Azure-palveluista, kuten App Servicestä. Ilman tätä sääntöä App Service ei pystyisi ottamaan yhteyttä tietokantaan, ja sovellus ei toimisi._

---

## Osa 4: Deployment ja turvallisuus

### Kysymys 15: What-if

Miksi `what-if` on tärkeä vaihe ennen deploymenttia? Anna esimerkki tilanteesta, jossa what-if estäisi ongelman.

_what-if näyttää mitä muutoksia deployment tekee ennen kuin mitään oikeasti muutetaan. Esimerkiksi jos olet vahingossa poistanut tärkeän resurssin koodista, what-if näyttää sen ennen kuin se poistetaan oikeasti._

### Kysymys 16: Tagit

Miksi kaikkiin Azure-resursseihin lisättiin tagit (`Application`, `Environment`, `ManagedBy`)? Miten ne hyödyttävät käytännössä?

_Tagit auttavat tunnistamaan mihin sovellukseen ja ympäristöön resurssi kuuluu. Käytännössä niiden avulla voi esimerkiksi laskea paljonko tietty sovellus maksaa, tai löytää helposti kaikki dev-ympäristön resurssit._

### Kysymys 17: Siivous ja kustannukset

Miksi on tärkeää poistaa kehitysresurssit Azuresta kun niitä ei enää tarvita? Mikä on helpoin tapa poistaa kaikki tämän tehtävän resurssit kerralla?

_Azure veloittaa resursseista jatkuvasti, vaikka niitä ei käytettäisi. Helpoin tapa poistaa kaikki resurssit on ajaa cleanup.ps1, joka poistaa koko resource groupin ja kaikki sen sisällä olevat resurssit kerralla._

---
