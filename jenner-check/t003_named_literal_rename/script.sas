/* Solution 2 (Joe Matise): named-literal rename on the INPUT dataset option.
   This form only works as an input data set option, not on output.
   From workarounds-for-sas-dataset-rename-bug.sas. */
data class;
  set sashelp.class(rename='Sex'n='sex'n);
run;

/* show the renamed variable in creation order */
proc contents data=class varnum;
run;
