def mathematica_repr(x):
    if type(x) == list or type(x) == tuple:
        return mathematica_list(x);
    elif type(x) == float:
        return ("%f" % x);
    else:
        return repr(x);

def mathematica_list(L):
    return "{"+(",".join([mathematica_repr(x) for x in L]))+"}";
