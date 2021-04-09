%% Experimentos com ELMK
%expr_elm_kernel('djia',1);
%expr_elm_kernel('yearly',1);
%expr_elm_kernel('MG_chaotic',1);
%expr_elm_kernel('SP500',1);
%expr_elm_kernel('santaFe',1);

%% Experimentos com o OS-ELMK
expr_os_elmk('yearly',2,1,'dec');
%expr_os_elmk('yearly',2,10,'dec');
expr_os_elmk('yearly',2,20,'dec');

%expr_os_elmk('MG_chaotic',4,1,'dec');
%expr_os_elmk('MG_chaotic',4,10,'dec');
%expr_os_elmk('MG_chaotic',4,20,'dec');

%expr_os_elmk('SP500',16,1,'dec');
%expr_os_elmk('SP500',16,10,'dec');
%expr_os_elmk('SP500',16,20,'dec');

%expr_os_elmk('santaFe',15,1,'dec');
%expr_os_elmk('santaFe',15,10,'dec');
%expr_os_elmk('santaFe',15,20,'dec');

%expr_os_elmk('djia',1,1);
%expr_os_elmk('djia',1,10);
%expr_os_elmk('djia',1,20);

%expr_os_elmk('yearly',1,1);
%expr_os_elmk('yearly',1,10);
%expr_os_elmk('yearly',1,20);

%expr_os_elmk('MG_chaotic',1,1);
%expr_os_elmk('MG_chaotic',1,10);
%expr_os_elmk('MG_chaotic',1,20);

%expr_os_elmk('djia',1,1,'dec');
%expr_os_elmk('djia',1,10,'dec');
%expr_os_elmk('djia',1,20,'dec');
