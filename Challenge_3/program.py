def get_value_from_nested_object(nested_object, key):
    keys = key.split('/')
    current_object = nested_object
    try:
        for k in keys:
            current_object = current_object[k]
        return current_object
    except (KeyError, TypeError):
        return None  
  
def test_get_value_from_nested_object():  
    assert get_value_from_nested_object({"a":{"b":{"c":"d"}}}, "a/b/c") == "d"  
    assert get_value_from_nested_object({"x":{"y":{"z":"a"}}}, "x/y/z") == "a"  
    assert get_value_from_nested_object({"a":{"b":{"c":"d"}}}, "a/b") == {"c":"d"}  
    assert get_value_from_nested_object({"x":{"y":{"z":"a"}}}, "x/y") == {"z":"a"}
    assert get_value_from_nested_object({"x":{"y":{"z":"a"}}}, "x") == {"y":{"z":"a"}} 
    assert get_value_from_nested_object({"x":{"y":{"z":"a"}}}, "a/b/c") == None  
  
    print("All tests passed!")
  
# Run tests
test_get_value_from_nested_object()

# Running function to output value
print(get_value_from_nested_object({"a":{"b":{"c":"d"}}}, "a/b/c"))