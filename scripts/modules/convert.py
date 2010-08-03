def mathematica_repr(x,collapse=False):
    if type(x) == list or type(x) == tuple:
        return mathematica_list(x,collapse);
    elif type(x) == float:
        return ("%f" % x);
    else:
        return repr(x);

def mathematica_list(L,collapse=False):
    if(collapse and len(L) == 1):
        return mathematica_repr(L[0],collapse);
    else:
        return "{"+(",".join([mathematica_repr(x,collapse) for x in L]))+"}";
