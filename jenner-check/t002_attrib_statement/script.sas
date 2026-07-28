/* Solution 1 (Joe Matise): pre-declare the lowercase sex variable with an
   ATTRIB statement before the SET, so it is created first in lowercase.
   From workarounds-for-sas-dataset-rename-bug.sas. */
data class;
  attrib sex length=$1;
  set sashelp.class;
run;quit;

/* show the renamed variable in creation order */
proc contents data=class varnum;
run;
