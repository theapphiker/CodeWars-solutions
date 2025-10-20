# This Python challenge flattens a nested dictionary.
# Link to challenge: https://www.codewars.com/kata/5cde541f52ed7f000c0aa9a0
def recursive_flatten(dict_item, dict_key):
    new_dict = {}
    if isinstance(dict_item, list):
        for i, e in enumerate(dict_item):
            new_key = f"{dict_key}[{i}]"
            if (isinstance(e, dict) or isinstance(e, list)) and len(e) > 0:
                new_dict.update(recursive_flatten(e, new_key))
            else:
                new_dict[new_key] = e
    else:
        for k, v in dict_item.items():
            new_key = f"{dict_key}.{k}"
            if (isinstance(v, dict) or isinstance(v, list)) and len(v) > 0:
                new_dict.update(recursive_flatten(v, new_key))
            else:
                new_dict[new_key] = v
    return new_dict

def flatten(x):
    d = {}
    for k, v in x.items():
        if (isinstance(v, dict) or isinstance(v, list)) and len(v) > 0:
            d.update(recursive_flatten(v, k))
        else:
            d[k] = v
    return d