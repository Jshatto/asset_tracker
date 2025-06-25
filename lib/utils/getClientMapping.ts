// getClientMapping (Run JS Code query, scoped Global)
const params = new URLSearchParams(window.location.search);
const raw = params.get("clientId");
const id  = (raw === null || raw === "null") ? 0 : parseInt(raw, 10);

return {
  currentClientId: id,             // 0 → “All Clients”
  isSuperAdmin:    id === 0,       // treat 0 as the super-admin/all-clients case
  displayText:     params.get("clientLabel") || "All Clients"
};
