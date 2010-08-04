from math import log, fabs, floor;

def mathematica_repr(x,collapse=False):
    if type(x) == list or type(x) == tuple:
        return mathematica_list(x,collapse);
    elif type(x) == str:
        return '"%s"' % x.encode("string_escape").replace('"',r'\"');
    elif type(x) == float:
        if(x==int(x)):
            return repr(x);
        else:
            e = floor(log(fabs(x))/log(10));
            if e <= -5 or e > 6:
                m = x/(10**e);
                return "%f*^%d" % (m,e);
            else:
                return "%f" % x;
    elif type(x) == dict:
        return mathematica_list([(k,x[k]) for k in x.keys()]);
    else:
        return repr(x);

def mathematica_list(L,collapse=False):
    if(collapse and len(L) == 1):
        return mathematica_repr(L[0],collapse);
    else:
        return "{"+(",".join([mathematica_repr(x,collapse) for x in L]))+"}";
