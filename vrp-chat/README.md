Når normale folk skriver i OOC, så det kun dem selv og staff der kan se det, hvorefter staff kan besvarer med **/r [id] [besked]**.

<b>Commands:</b>
<ul>
  <li><b>/r [id] [besked]</b>: kan også bruges hvis staff bare skal sende en besked til en person.</li>
  <li><b>/ooc [besked]</b>: Kan bruges af staff, hvis det en besked alle skal have.</li>
  <li><b>/pk og /ck [besked]</b>: Kan bruges af normale spillere. (De skal slåes fra i config) <b>BEMÆRK:</b> Personens ID der skriver commanden er skjult, husk og ændrer webhook i config, for at kunne se id'et</li>
</ul>

**Når en spiller skriver i OOC:**
<br/><img width='100%' src="https://i.gyazo.com/bab758513456c42a4e768a99048b4e94.png">

**Når en staff besvarer med /r [id] [besked]:**
<br/><img width='100%' src="https://i.gyazo.com/d8956ed5d1e54bf605921ddc808018cd.png">


**Installation i [system]/chat/sv_chat.lua:**
<br/><img width='100%' src="https://i.gyazo.com/9deb2f0612c4c49ea15a55fe015b1dde.png">

**Kode:** ```TriggerEvent("vrp-chat:chat_message",source,author,message)```
