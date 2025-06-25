// Query name: createView (JavaScript)
const taxRes  = await calculateTaxDepreciation.trigger();  // runs your SQL calculateTaxDepreciation query
const bookRes = await calculateBookDepreciation.trigger(); // runs your SQL calculateBookDepreciation query

// Both return arrays of rows with { asset_id, depreciation_date, current_year_dep, accum_dep }
// We tag them with a schedule_type so you can distinguish
const taxRows  = (taxRes.data  || []).map(r => ({ ...r, schedule_type: 'tax'  }));
const bookRows = (bookRes.data || []).map(r => ({ ...r, schedule_type: 'book' }));

// Return the unified array
return [...taxRows, ...bookRows];
