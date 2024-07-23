%let pgm=utl-workarounds-for-sas-dataset-rename-bug;

Workarounds for sas dataset rename bug

Thanks to the SAS-L Brain Trust

 Solutions

     0 rename on input dataset
       Tom Robison
       barefootguru@gmail.com

     1 atrib statement
       Joe Matise <snoopy369@GMAIL.COM>

     2 named literals
       only workss as a input dataset option
       Joe Matise <snoopy369@GMAIL.COM>

     3 proc sql
       Louise Hadden

     4 Using Barts macros
       https://github.com/yabwon (for excellent documentation)
       Bartosz Jablonski yabwon@gmail.com
       Barts macros on end and in
       https://tinyurl.com/y9nfugth
       https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories
       I had to rename them because of conflicts with my macros

     4 Ted Clay, M.S. tclay@ashlandhome.net
       Søren Lassen, s.lassen@post.tele.dk macros

     5 Barts macros

github
https://tinyurl.com/4vse3bwn
https://github.com/rogerjdeangelis/workarounds-for-sas-dataset-rename-bug

macros
https://tinyurl.com/y9nfugth
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories

As a side note:
The option VALIDMEMNAME=EXTEND allows you to read or create sas objects like datasets
whose name having spaces or special characters,

options VALIDMEMNAME=EXTEND;
data 'Student Class'n;
  set sashelp.class;
run;quit;

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/**************************************************************************************************************************/
/*                                                                                                                        */
/*   RENAME THE MIXED CASE 'SEX' VARIABLE NAME TO LOWERCASE 'SEX'.                                                        */
/*   NONE OF THE ATTEMPTS BELOW WORK.                                                                                     */
/*                                                                                                                        */
/*------------------------------------------------------------------------------------------------------------------------*/
/*                                                                                                                        */
/*   options validvarname=any;                                                                                            */
/*                                                                                                                        */
/*   data class(rename=Sex='sex'n);                                                                                       */
/*     set sashelp.class;                                                                                                 */
/*   run;quit;                                                                                                            */
/*                                                                                                                        */
/*   #    Variable    Type    Len                                                                                         */
/*        Sex         Char      1    Failed should be lowercase 'sex'                                                     */
/*                                                                                                                        */
/*   data class(rename=Sex=sex);                                                                                          */
/*     set sashelp.class;                                                                                                 */
/*   run;quit;                                                                                                            */
/*                                                                                                                        */
/*   #    Variable    Type    Len                                                                                         */
/*        Sex         Char      1                                                                                         */
/*                                                                                                                        */
/*   data class;                                                                                                          */
/*     set sashelp.class;                                                                                                 */
/*     sex=trim(Sex);                                                                                                     */
/*   run;quit;                                                                                                            */
/*                                                                                                                        */
/*   #    Variable    Type    Len                                                                                         */
/*        Sex         Char      1                                                                                         */
/*                                                                                                                        */
/*                                                                                                                        */
/*                                                                                                                        */
/* THIS SHOUL NOT WORK!                                                                                                   */
/*                                                                                                                        */
/* Bartosz Jablonski                                                                                                      */
/* yabwon@gmail.com                                                                                                       */
/*                                                                                                                        */
/* This may be required for legacy reasons.                                                                               */
/* I suspect WPS/Altair has it right?                                                                                     */
/*                                                                                                                        */
/* Proc datasets should know that                                                                                         */
/* variable name 'A' is different from variable name 'a'                                                                  */
/* and not do the rename.                                                                                                 */
/* Datastep variables are case insensitive but                                                                            */
/* proc datasets should recognize case differences                                                                        */
/*                                                                                                                        */
/*  data test;                                                                                                            */
/*    A=42;                                                                                                               */
/*  run;                                                                                                                  */
/*                                                                                                                        */
/*  #    Variable    Type    Len                                                                                          */
/*                                                                                                                        */
/*  1    A           Num       8                                                                                          */
/*                                                                                                                        */
/*  THIS SHOULD NOT WORK!                                                                                                 */
/*                                                                                                                        */
/*  For two reasons, A is not in test dataset                                                                             */
/*  and renaming to the same name should at                                                                               */
/*  least issue a warning.                                                                                                */
/*                                                                                                                        */
/*  proc datasets lib=work nolist nowarn;                                                                                 */
/*  modify test;                                                                                                          */
/*    rename                                                                                                              */
/*      a=a  /* keep lower case */                                                                                        */
/*    ;                                                                                                                   */
/*  run;quit;                                                                                                             */
/*                                                                                                                        */
/*   Variables in Creation Order                                                                                          */
/*                                                                                                                        */
/*  #    Variable    Type    Len                                                                                          */
/*                                                                                                                        */
/*  1    a           Num       8                                                                                          */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                                                          _                   _       
 / _ \  _ __ ___ _ __ ___   __ _ _ __ ___   ___    ___  _ __  (_)_ __  _ __  _   _| |_     
| | | || `__/ _ \ `_ ` _ \ / _` | `_ ` _ \ / _ \  / _ \| `_ \ | | `_ \| `_ \| | | | __|    
| |_| || | |  __/ | | | | | (_| | | | | | |  __/ | (_) | | | || | | | | |_) | |_| | |_     
 \___/ |_|  \___|_| |_| |_|\__,_|_| |_| |_|\___|  \___/|_| |_||_|_| |_| .__/ \__,_|\__|    
                                                                      |_|                  
*/                                                                                         


options validvarname=any;
data class;
  set sashelp.class(rename=Sex=sex);
run;

/*         _        _ _           _        _                            _
/ |   __ _| |_ _ __(_) |__    ___| |_ __ _| |_ ___ _ __ ___   ___ _ __ | |_
| |  / _` | __| `__| | `_ \  / __| __/ _` | __/ _ \ `_ ` _ \ / _ \ `_ \| __|
| | | (_| | |_| |  | | |_) | \__ \ || (_| | ||  __/ | | | | |  __/ | | | |_
|_|  \__,_|\__|_|  |_|_.__/  |___/\__\__,_|\__\___|_| |_| |_|\___|_| |_|\__|

*/

options validvarname=any;
data class;
  attrib sex length=$1;
  set sashelp.class;
run;quit;

 Variables in Creation Order

#    Variable    Type    Len

1    sex         Char      1

/*___                                   _   _ _ _                 _
|___ \   _ __   __ _ _ __ ___   ___  __| | | (_) |_ ___ _ __ __ _| |___
  __) | | `_ \ / _` | `_ ` _ \ / _ \/ _` | | | | __/ _ \ `__/ _` | / __|
 / __/  | | | | (_| | | | | | |  __/ (_| | | | | ||  __/ | | (_| | \__ \
|_____| |_| |_|\__,_|_| |_| |_|\___|\__,_| |_|_|\__\___|_|  \__,_|_|___/

*/

* Does not work with literal rename on output dataset option or datastep rename statement.
data class;
  set sashelp.class(rename='Sex'n='sex'n);
run;

 Variables in Creation Order

#    Variable    Type    Len

1    sex         Char      1


/*____                                    _
|___ /   _ __  _ __ ___   ___   ___  __ _| |
  |_ \  | `_ \| `__/ _ \ / __| / __|/ _` | |
 ___) | | |_) | | | (_) | (__  \__ \ (_| | |
|____/  | .__/|_|  \___/ \___| |___/\__, |_|
        |_|                            |_|
*/

proc sql;
 create
    table class as
 select
    Sex as sex
 from
    sashelp.class
;quit;

 Variables in Creation Order

#    Variable    Type    Len

1    sex         Char      1

/*  _     ____             _
| || |   | __ )  __ _ _ __| |_ ___   _ __ ___   __ _  ___ _ __ ___  ___
| || |_  |  _ \ / _` | `__| __/ __| | `_ ` _ \ / _` |/ __| `__/ _ \/ __|
|__   _| | |_) | (_| | |  | |_\__ \ | | | | | | (_| | (__| | | (_) \__ \
   |_|   |____/ \__,_|_|   \__|___/ |_| |_| |_|\__,_|\___|_|  \___/|___/
 _                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

data class;
set sashelp.class;
run;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*   Variables in Creation Order                                                                                          */
/*                                                                                                                        */
/*  #    Variable    Type    Len                                                                                          */
/*                                                                                                                        */
/*  1    Name        Char      8                                                                                          */
/*  2    Sex         Char      1                                                                                          */
/*  3    Age         Num       8                                                                                          */
/*  4    Height      Num       8                                                                                          */
/*  5    Weight      Num       8                                                                                          */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

/*----                                                                   ----*/
/*---- macros on end of this message                                     ----*/
/*----                                                                   ----*/

%macro VarsToLowcase(lib,ds);

  %bgetVars(&lib..&ds.,mcArray=___vars)

  PROC DATASETS LIB=&lib. NOLIST;
  MODIFY &ds.;
    RENAME
      %do_over(___vars,phrase=%nrstr(
        %___vars(&_I_.)=%lowcase(%___vars(&_I_.))
      ))
    ;
    RUN;
  QUIT;

  %bdeleteMacArray(___vars, macarray=Y)

%mend VarsToLowcase;

%VarsToLowcase(work,class)

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  Variables in Creation Order                                                                                           */
/*                                                                                                                        */
/* #    Variable    Type    Len                                                                                           */
/*                                                                                                                        */
/* 1    name        Char      8                                                                                           */
/* 2    sex         Char      1                                                                                           */
/* 3    age         Num       8                                                                                           */
/* 4    height      Num       8                                                                                           */
/* 5    weight      Num       8                                                                                           */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___         _
| ___|    ___| | __ _ _   _   ___  ___  _ __ ___ _ __
|___ \   / __| |/ _` | | | | / __|/ _ \| `__/ _ \ `_ \
 ___) | | (__| | (_| | |_| | \__ \ (_) | | |  __/ | | |
|____/   \___|_|\__,_|\__, | |___/\___/|_|  \___|_| |_|
                      |___/
*/

options validvarname=any;
data class;
set sashelp.class;
run;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  Variables in Creation Order                                                                                           */
/*                                                                                                                        */
/* #    Variable    Type    Len                                                                                           */
/*                                                                                                                        */
/* 1    Name        Char      8                                                                                           */
/* 2    Sex         Char      1                                                                                           */
/* 3    Age         Num       8                                                                                           */
/* 4    Height      Num       8                                                                                           */
/* 5    Weight      Num       8                                                                                           */
/*                                                                                                                        */
/**************************************************************************************************************************/

%array(_vars,values=%utl_varlist(class));

%put &=_varsn; * _VARSN=5  ;
%put &=_vars3; * _VARSN=Age;

proc datasets;
  modify class;
  rename
    %do_over(_vars,phrase=%nrstr(?=%lowcase(?)));
  ;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* NOTE: Renaming variable Name to name.                                                                                  */
/* NOTE: Renaming variable Sex to sex.                                                                                    */
/* NOTE: Renaming variable Age to age.                                                                                    */
/* NOTE: Renaming variable Height to height.                                                                              */
/* NOTE: Renaming variable Weight to weight.                                                                              */
/*                                                                                                                        */
/*                                                                                                                        */
/*   Variables in Creation Order                                                                                          */
/*                                                                                                                        */
/*  #    Variable    Type    Len                                                                                          */
/*                                                                                                                        */
/*  1    name        Char      8                                                                                          */
/*  2    sex         Char      1                                                                                          */
/*  3    age         Num       8                                                                                          */
/*  4    height      Num       8                                                                                          */
/*  5    weight      Num       8                                                                                          */
/*                                                                                                                        */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*__     _                _
 / /_   | |__   __ _ _ __| |_ ___   _ __ ___   __ _  ___ _ __ ___  ___
| `_ \  | `_ \ / _` | `__| __/ __| | `_ ` _ \ / _` |/ __| `__/ _ \/ __|
| (_) | | |_) | (_| | |  | |_\__ \ | | | | | | (_| | (__| | | (_) \__ \
 \___/  |_.__/ \__,_|_|   \__|___/ |_| |_| |_|\__,_|\___|_|  \___/|___/

*/


filename ft15f001 "c:/oto/bdeleteMacArray.sas";
parmcards4;
%macro bdeleteMacArray(
  arrs
, macarray = N
)
/ minoperator
;
%local I J rc;
%do I = 1 %to %sysfunc(countw(&arrs.));
%let arr = %scan(&arrs., &I., %str( ));
  %do J = &&&arr.LBOUND %to &&&arr.HBOUND;
    /*%put *&arr.&J.*;*/
    %symdel &arr.&J. / NOWARN;
  %end;
  %symdel &arr.LBOUND &arr.HBOUND &arr.N / NOWARN;
%end;

%if %qupcase(&macarray.) in (Y YES) %then
  %do;
  %let rc = %sysfunc(dosubl(
  /*+++++++++++++++++++++++++++++++++++++++++++++*/
  options nonotes nosource %str(;)
  proc sql noprint %str(;)
    create table _%sysfunc(datetime(), hex16.)_ as
    select memname %str(,) objname
    from dictionary.catalogs
    where
      objname in (%upcase(
      %str(%")%qsysfunc(tranwrd(&arrs., %str( ), %str(%",%")))%str(%")
      ))
      and objtype = 'MACRO'
      and libname  = 'WORK'
    order by memname %str(,) objname
    %str(;)
  quit %str(;)
  data _null_ %str(;)
    do until(last.memname) %str(;)
      set _last_ %str(;)
      by memname %str(;)

      if first.memname then
      call execute('proc catalog cat = work.'
                 !! strip(memname)
                 !! ' et = macro force;') %str(;)
      call execute('delete '
                 !! strip(objname)
                 !! '; run;') %str(;)
    end %str(;)
    call execute('quit;') %str(;)
  run %str(;)
  proc delete data = _last_ %str(;)
  run %str(;)
  /*+++++++++++++++++++++++++++++++++++++++++++++*/
  ));
  %end;
%mend bdeleteMacArray;
;;;;
run;quit;



filename ft15f001 "c:/oto/bdo_over.sas";
parmcards4;
%macro bdo_over(
  array
, phrase=%nrstr(%&array(&_I_.))
, between=%str( )
, which =
);
%local _I_ _wc_ _w_ start end by _first_;
%if %superq(which) = %then
  %do;
    /* execute the loop for ALL elements */
    %do _I_ = &&&array.LBOUND %to &&&array.HBOUND;
      %if &_I_. NE &&&array.LBOUND %then %do;%unquote(&between.)%end;%unquote(%unquote(&phrase.))
    %end;
  %end;
%else
  %do;
    %do _wc_ = 1 %to %qsysfunc(countw(&which., %str( )));
      %let _w_ = %qscan(&which., &_wc_., %str( ));

      %let start = %qupcase(%qscan(&_w_., 1, :));
      %let end   = %qupcase(%qscan(&_w_., 2, :));
      %let by    = %qupcase(%qscan(&_w_., 3, :));

      /* testing conditions for START */
      %if %superq(start) = H %then %let start = &&&array.HBOUND;
      %else
        %if %superq(start) = L %then %let start = &&&array.LBOUND;

      /* testing conditions for END */
      %if %superq(end) = %then %let end = %sysevalf(&start.);
      %else
        %if %superq(end) = H %then %let end = &&&array.HBOUND;
        %else
          %if %superq(end) = L %then %let end = &&&array.LBOUND;

      /* testing conditions for BY */
      %if %superq(by) = %then %let by = 1;

      /* execute the loop over selected elements */
      %do _I_ = &start. %to &end. %by &by.;
        %if &_first_. NE %then %do;%unquote(&between.)%end;%else%do;%let _first_=!;%end;%unquote(%unquote(&phrase.))
      %end;
    %end;
  %end;
%mend bdo_over;
;;;;
run;quit;




filename ft15f001 "c:/oto/bgetVars.sas";
parmcards4;
%macro bgetVars(
  ds               /* Name of the dataset, required. */
, sep = %str( )    /* Variables separator, space is the default one. */
, pattern = .*     /* Variable name regexp pattern, .*(i.e. any text) is the default, case INSENSITIVE! */
, varRange = _all_ /* Named range list of variables, _all_ is the default. */
, quote =          /* Quotation symbol to be used around values, blank is the default */
, mcArray =        /* Name of macroArray to be generated from list of variables */
)
/des = 'The %getVars() and %QgetVars() macro functions allows to extract variables list from dataset.'
;
/*%local t;*/
/*%let t = %sysfunc(time());*/

  %local VarList di dx i VarName VarCnt;
  %let VarCnt = 0;

  %let di = %sysfunc(open(&ds.(keep=&varRange.), I)); /* open dataset with subset of variables */
  %let dx = %sysfunc(open(&ds.                 , I)); /* open dataset with ALL variables */
  %if &di. > 0 %then
    %do;
      %do i = 1 %to %sysfunc(attrn(&dx., NVARS)); /* iterate over ALL variables names */
        %let VarName = %sysfunc(varname(&dx., &i.));

        %if %sysfunc(varnum(&di., &VarName.)) > 0 /* test if the variable is in the subset */
            AND
            %sysfunc(prxmatch(/%bquote(&pattern.)/i, &VarName.)) > 0 /* check the pattern */
        %then
          %do;
            %let VarCnt = %eval(&VarCnt. + 1);
            %if %superq(mcArray) = %then
              %do;
                %local VarList&VarCnt.;
                  %let VarList&VarCnt. = %nrbquote(&quote.)&VarName.%nrbquote(&quote.);
              %end;
            %else
              %do;
                %global &mcArray.&VarCnt.;
                   %let &mcArray.&VarCnt. = %unquote(%nrbquote(&quote.)&VarName.%nrbquote(&quote.));
              %end;
            /*
            %if %bquote(&VarList.) = %then
              %let VarList = %nrbquote(&quote.)&VarName.%nrbquote(&quote.);
            %else
              %let VarList = &VarList.%nrbquote(&sep.)%nrbquote(&quote.)&VarName.%nrbquote(&quote.);
            */
          %end;
      %end;
    %end;
  %let di = %sysfunc(close(&di.));
  %let dx = %sysfunc(close(&dx.));
/*%put (%sysevalf(%sysfunc(time()) - &t.));*/
%if %superq(mcArray) = %then
  %do;
    %do i = 1 %to &VarCnt.;%unquote(&&VarList&i.)%if &i. NE &VarCnt. %then %do;%unquote(&sep.)%end;%end;
  %end;
%else
  %do;
  /*-----------------------------------------------------------------------------------------------------------*/
    %put NOTE-;
    %put NOTE: When mcArray= parameter is active the getVars macro cannot be called within the %nrstr(%%put) statement.;
    %put NOTE: Execution like: %nrstr(%%put %%getVars(..., mcArray=XXX)) will result with an e.r.r.o.r.;
               /*e.r.r.o.r. - explicit & radical refuse of run */
    %put NOTE-;
    %local mtext rc;
    %let mtext = _%sysfunc(int(%sysevalf(1000000000 * %sysfunc(rand(uniform)))))_;
    %global &mcArray.LBOUND &mcArray.HBOUND &mcArray.N;
    %let &mcArray.LBOUND = 1;
    %let &mcArray.HBOUND = &VarCnt.;
    %let &mcArray.N      = &VarCnt.;
    %let rc = %sysfunc(doSubL( /*%nrstr(%%put ;)*/
    /*===============================================================================================*/
      options nonotes nosource %str(;)
      DATA _NULL_ %str(;)
       IF %unquote(&VarCnt.) > 0
       THEN
         CALL SYMPUTX("&mtext.",
          ' %MACRO ' !! "&mcArray." !! '(J,M);' !!
          '%local J M; %if %qupcase(&M.)= %then %do;' !! /* empty value is output, I is input */
          '%if %sysevalf( (&&&sysmacroname.LBOUND LE &J.) * (&J. LE &&&sysmacroname.HBOUND) ) %then %do;&&&sysmacroname.&J.%end;' !!
          '%else %do; ' !!
            '%put WARNING:[Macroarray &sysmacroname.] Index &J. out of range.;' !!
            '%put WARNING-[Macroarray &sysmacroname.] Should be between &&&sysmacroname.LBOUND and &&&sysmacroname.HBOUND;' !!
            '%put WARNING-[Macroarray &sysmacroname.] Missing value is used.;' !!
          '%end;' !!
          '%end;' !!
          '%else %do; %if %qupcase(&M.)=I %then %do;' !!
          '%if %sysevalf( (&&&sysmacroname.LBOUND LE &J.) * (&J. LE &&&sysmacroname.HBOUND) ) %then %do;&sysmacroname.&J.%end;' !!
          '%else %do;' !!
            '%put ERROR:[Macroarray &sysmacroname.] Index &J. out of range.;' !!
            '%put ERROR-[Macroarray &sysmacroname.] Should be between &&&sysmacroname.LBOUND and &&&sysmacroname.HBOUND;' !!
          '%end;' !!
          '%end; %end;' !!
          '%MEND;', 'G') %str(;)
       ELSE
         CALL SYMPUTX("&mtext.", ' ', 'G') %str(;)
       STOP %str(;)
      RUN %str(;)
    /*===============================================================================================*/
    )); &&&mtext. %symdel &mtext. / NOWARN ;
    %put NOTE:[&sysmacroname.] &VarCnt. macro variables created;
  /*-----------------------------------------------------------------------------------------------------------*/
  %end;
%mend bgetVars;
;;;;
run;quit;

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

