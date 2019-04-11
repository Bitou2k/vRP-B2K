function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
  AddTextEntry('FE_THDR_GTAO', 'B2K Roleplay')
  AddTextEntry('PM_PANE_LEAVE', 'Sair do B2K Roleplay')
end)
