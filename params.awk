BEGIN {
    types[0] = "pstring";
    types[1] = "pint";
    types[2] = "punsigned";
    types[3] = "pbool";
    types[4] = "pfloat";
    types[5] = "pdouble";
    types[6] = "pdouble";
    types[7] = "pcolormap";
    print "// Automatically generated by params.awk"
    print "#include \"parse.h\""
}
{
    if ($1 == "struct" && $3 == "{") {
	struct = $2;
	print "\nbool " struct "_get (struct " struct " * p) {"
	print "  Params params[] = {"
	while (getline && $1 != "};") {
	    type = -1;
	    pos = 2;
	    if ($2 == "*") {
		if ($1 == "char") {
		    type = 0; pos = 3;
		}
	    }
	    else if ($1 == "int")
		type = 1;
	    else if ($1 == "unsigned")
		type = 2;
	    else if ($1 == "bool")
		type = 3;
	    else if ($1 == "float")
		type = 4;
	    else if ($1 == "double")
		type = 5;
	    else if ($1 == "coord")
		type = 6;
	    else if ($1 == "colormap")
		type = 7;
	    if (type >= 0) {
		a = "";
		for (i = pos; i <= NF; i++)
		    a = a $i;
		split (a, b, ",|;");
		for (i in b)
		    if (b[i] != "" && substr (b[i],1,1) != "/") {
			if (gsub ("[\\[\\]]", " ", b[i])) {
			    split (b[i], c, " ");
			    print "    {\"" c[1] "\", " types[type]	\
				", p->" c[1] ", " c[2] "},";
			}
			else if (type == 6)
			    print "    {\"" b[i] "\", " types[type]	\
				", &p->" b[i] ", 3},";
			else
			    print "    {\"" b[i] "\", " types[type]	\
				", &p->" b[i] "},";
		    }
	    }
	}
	print "    {NULL}\n  };"
	print "  return parse_params (params);"
	print "}"
    }
}
