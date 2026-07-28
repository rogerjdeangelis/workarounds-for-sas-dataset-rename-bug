/* Solution 0 (Tom Robison): rename the mixed-case Sex variable to
   lowercase sex via a RENAME= data set option on the INPUT dataset.
   From workarounds-for-sas-dataset-rename-bug.sas. */
data class;
  set sashelp.class(rename=Sex=sex);
run;

/* show the renamed variable in creation order */
proc contents data=class varnum;
run;
