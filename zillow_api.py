from pyzillow.pyzillow import ZillowWrapper, GetDeepSearchResults

address = 'New York'
zipcode = '10001'
zillow_data = ZillowWrapper('X1-ZWz19gp4nlswln_22g4o')
deep_search_response = zillow_data.get_deep_search_results(address, zipcode)
result = GetDeepSearchResults(deep_search_response)
result.zillow_id # zillow id, needed for the GetUpdatedPropertyDetails