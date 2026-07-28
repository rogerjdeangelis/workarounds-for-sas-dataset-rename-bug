/* Solution 3 (Louise Hadden): use a PROC SQL column alias to project
   Sex to lowercase sex.
   From workarounds-for-sas-dataset-rename-bug.sas. */
proc sql;
 create
    table class as
 select
    Sex as sex
 from
    sashelp.class
;quit;

/* show the renamed variable in creation order */
proc contents data=class varnum;
run;
