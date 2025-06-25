// Transformer for getDepByYear
// `data` is automatically `getDepByYear.data`
const rows = Array.isArray(data) ? data : [];
const selectedYears = Array.isArray(yearMultiSelect.data)
  ? yearMultiSelect.data.map(Number)
  : [];

// Build one series per selected year
return selectedYears.map(year => ({
  label: String(year),
  data: rows
    .filter(r => r.year === year)
    .map(r => ({ x: r.year, y: r.dep_amount }))
}));
