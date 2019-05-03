vrp_extended, gør så man kan se inventory, job og penge client sided på alle på serveren.

<b>For at få det hele til og virke:</b>

<b>vrp/base</b>
<ul>
  <li>http://prntscr.com/nj9d31</li>
</ul>

<b>Kode:</b> vRPex = Proxy.getInterface("vrp_extended")

<b>vrp/modules/money</b>
<ul>
  <li>http://prntscr.com/nj925i</li>
  <li>http://prntscr.com/nj92nm</li>
</ul>

<b>Kode:</b>vRPex.updateMoney({user_id,tmp.bank,tmp.wallet})

<b>vrp/modules/inventory</b>
<ul>
  <li>http://prntscr.com/nj94xl</li>
  <li>http://prntscr.com/nj9573</li>
  <li>http://prntscr.com/nj95ao</li>
  <li>Smid nedenstående function ind også lige over clearInventory functionen, hvis du ikke allerede har den.</li>
</ul>

```
function vRP.getInventory(user_id)
  local data = vRP.getUserDataTable(user_id)
  if data then
    return data.inventory
  end
end
```

<b>Kode:</b> vRPex.updateInventory({user_id,data.inventory,vRP.getInventoryWeight(user_id)})
