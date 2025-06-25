// Query name: getDepSeries (Run JS Code)

// 1) grab your SQL rows
const rows = getDepByYear.data || [];

// 2) grab the years the user picked
const years = Array.isArray(baseYear.value)
  ? baseYear.value.map(Number)
  : [];

// 3) build one series per year
const series = years.map(year => ({
  label: String(year),
  data: rows
    .filter(r => r.year === year)
    .map(r => ({ x: r.year, y: r.dep_amount })),
}));

// 4) return it
return series;
