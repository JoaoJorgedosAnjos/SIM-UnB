INSERT INTO campus (nome_campus, endereco_campus) VALUES
('Darcy Ribeiro', 'Asa Norte, Brasília-DF'),
('Gama (FGA)', 'Setor Leste, Gama-DF'),
('Ceilândia (FCE)', 'QNN 14, Ceilândia-DF'),
('Planaltina (FUP)', 'Área Universitária, Planaltina-DF');

SELECT * FROM CAMPUS;

ALTER TABLE MATERIAS ADD COLUMN cod_oficial VARCHAR(10) UNIQUE;

ALTER TABLE MATERIAS RENAME COLUMN cod_oficial TO cod_disciplina;

INSERT INTO MATERIAS (cod_disciplina, nome_materia, horas) VALUES
-- 1º Semestre
('CIC0004', 'ALGORITMOS E PROGRAMAÇÃO DE COMPUTADORES', 90),
('CIC0005', 'FORMAÇÃO DOCENTE EM COMPUTAÇÃO', 60),
('PAD0028', 'ORGANIZAÇÃO DA EDUCAÇÃO BRASILEIRA', 60),
-- 2º Semestre
('CIC0002', 'FUNDAMENTOS TEÓRICOS DA COMPUTAÇÃO', 60),
('CIC0090', 'ESTRUTURAS DE DADOS', 60),
('MAT0025', 'CÁLCULO 1', 90),
('TEF0011', 'PSICOLOGIA DA EDUCAÇÃO', 60),
-- 3º Semestre
('CIC0182', 'LÓGICA COMPUTACIONAL 1', 60),
('CIC0197', 'TECNICAS DE PROGRAMAÇÃO 1', 60),
('EST0022', 'PROBABILIDADE E ESTATÍSTICA', 90),
('MAT0031', 'INTRODUCAO A ALGEBRA LINEAR', 60),
-- Novas Disciplinas
('CIC0092', 'ORGANIZAÇÃO DE ARQUIVOS', 60),
('CIC0093', 'LINGUAGENS DE PROGRAMACAO', 60),
('CIC0177', 'ARQUITETURA DE PROCESSADORES DIGITAIS', 60),
('CIC0206', 'MÉTODOS DE PESQUISA NA LICENCIATURA EM COMPUTAÇÃO', 30),
('MAT0026', 'CÁLCULO 2', 90);

select * from materias;

INSERT INTO UNIDADE_ACADEMICA (nome_unidade, sigla_unidade, tipo_unidade, id_campus) VALUES
('Instituto de Ciências Exatas', 'IE', 'Instituto', 1),
('Faculdade de Educação', 'FE', 'Faculdade', 1),
('Instituto de Artes', 'IDA', 'Instituto', 1),
('Faculdade de Tecnologia', 'FT', 'Faculdade', 1),
('Faculdade de Medicina', 'FM', 'Faculdade', 1);

select * from unidade_academica;

ALTER TABLE DEPARTAMENTO ADD COLUMN sigla_departamento VARCHAR(10) UNIQUE;

ALTER TABLE MATERIAS ADD COLUMN cod_departamento INT;

ALTER TABLE MATERIAS ADD CONSTRAINT fk_materias_departamento
    FOREIGN KEY (cod_departamento) REFERENCES DEPARTAMENTO(cod_departamento);

INSERT INTO DEPARTAMENTO (nome_departamento, id_unidade, sigla_departamento) VALUES
('Departamento de Ciência da Computação', 1, 'CIC'),
('Departamento de Matemática', 1, 'MAT'),
('Departamento de Estatística', 1, 'EST');

-- Ligar matérias do CIC (cod_departamento = 1)
UPDATE MATERIAS
SET cod_departamento = 1
WHERE cod_disciplina LIKE 'CIC%';

-- Ligar matérias da Matemática (cod_departamento = 2)
UPDATE MATERIAS
SET cod_departamento = 2
WHERE cod_disciplina LIKE 'MAT%';

-- Ligar matérias da Estatística (cod_departamento = 3)
UPDATE MATERIAS
SET cod_departamento = 3
WHERE cod_disciplina LIKE 'EST%';

INSERT INTO DEPARTAMENTO (nome_departamento, id_unidade, sigla_departamento) VALUES
('Departamento de Métodos e Técnicas', 2, 'MTC'),
('Departamento de Políticas Públicas e Gestão da Educação', 2, 'PEG'),
('Departamento de Teoria e Fundamentos', 2, 'TEF');

UPDATE MATERIAS
SET cod_departamento = (SELECT cod_departamento FROM DEPARTAMENTO WHERE sigla_departamento = 'PEG')
WHERE cod_disciplina LIKE 'PAD%';

select * from departamento;

INSERT INTO DEPARTAMENTO (nome_departamento, id_unidade, sigla_departamento) VALUES
('Departamento de Música', 3, 'MUS'),
('Departamento de Artes Cênicas', 3, 'CEN'),
('Departamento de Design', 3, 'DIN');

INSERT INTO DEPARTAMENTO (nome_departamento, id_unidade, sigla_departamento) VALUES
('Departamento de Engenharia Civil e Ambiental', 4, 'ENC'),
('Departamento de Engenharia Elétrica', 4, 'ENE'),
('Departamento de Engenharia Florestal', 4, 'EFL'),
('Departamento de Engenharia Mecânica', 4, 'ENM'),
('Departamento de Engenharia de Produção', 4, 'EPR');

INSERT INTO DEPARTAMENTO (nome_departamento, id_unidade, sigla_departamento) VALUES
('Departamento de Clínica Médica', 5, 'DCM'),
('Departamento de Cirurgia', 5, 'DC'),
('Departamento de Saúde Coletiva', 5, 'DSC'),
('Departamento de Saúde Materno-Infantil', 5, 'DSMI'),
('Departamento de Genética e Biologia Molecular', 5, 'DGBM');

select * from departamento

INSERT INTO CURSO (nome_curso, cod_departamento, nivel_curso) VALUES

    ('Ciência da Computação (Bacharelado)', 1, 'Graduação'),
    ('Ciência da Computação (Licenciatura)', 1, 'Graduação'),


    ('Bacharelado em Matemática', 2, 'Graduação'),
    ('Licenciatura em Matemática (Diurno)', 2, 'Graduação'),
    ('Licenciatura em Matemática (Noturno)', 2, 'Graduação'),


    ('Pedagogia (Diurno)', 5, 'Graduação'),
    ('Pedagogia (Noturno)', 5, 'Graduação'),

    ('Engenharia de Computação', 1, 'Graduação');

select * from curso;

UPDATE CURSO
SET nome_curso = 'Computação (Licenciatura)'
WHERE nome_curso = 'Ciência da Computação (Licenciatura)' AND cod_departamento = 1;

INSERT INTO GRADE_CURRICULAR (cod_curso, cod_materia, semestre_sugerido, tipo_materia) VALUES
-- 1º Semestre
((SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0004'), 1, 'Obrigatória'),
((SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0005'), 1, 'Obrigatória'),
((SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), 1, 'Obrigatória'),

-- 2º Semestre
((SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0002'), 2, 'Obrigatória'),
((SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0090'), 2, 'Obrigatória'),
((SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0025'), 2, 'Obrigatória'),
((SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'TEF0011'), 2, 'Optativa'),

-- 3º Semestre
((SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0182'), 3, 'Obrigatória'),
((SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0197'), 3, 'Obrigatória'),
((SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'EST0022'), 3, 'Obrigatória'),

-- 4º Semestre
((SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0031'), 4, 'Obrigatória'),
((SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0092'), 4, 'Obrigatória'),
((SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0093'), 4, 'Obrigatória'),
((SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0177'), 4, 'Obrigatória'),
((SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0206'), 4, 'Obrigatória');

select * from grade_curricular;

SELECT
    c.nome_curso,          -- Seleciona o nome da tabela CURSO
    m.cod_disciplina,      -- Seleciona o código da disciplina da tabela MATERIAS
    m.nome_materia,        -- Seleciona o nome da matéria da tabela MATERIAS
    g.semestre_sugerido,   -- Seleciona o semestre da tabela GRADE_CURRICULAR
    g.tipo_materia         -- Seleciona o tipo da tabela GRADE_CURRICULAR
FROM
    grade_curricular AS g -- Começamos pela grade_curricular (e damos o apelido "g")
        JOIN
    CURSO AS c ON g.cod_curso = c.cod_curso -- Juntamos com CURSO (apelido "c") onde os IDs batem
        JOIN
    MATERIAS AS m ON g.cod_materia = m.cod_mat; -- Juntamos com MATERIAS (apelido "m") onde os IDs batem

INSERT INTO PRE_REQUISITO (cod_materia, cod_pre_requisito) VALUES
-- Pré-requisito de Cálculo 2
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0026'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0025')),

-- Pré-requisito de Estruturas de Dados
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0090'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0004')),

-- Pré-requisito de Lógica Computacional 1
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0182'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0002')),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0182'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0090')),

-- Pré-requisito de Técnicas de Programação 1
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0197'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0090')),

-- Pré-requisitos de Organização de Arquivos
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0092'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'EST0022')),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0092'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0090')),

-- Pré-requisito de Linguagens de Programação
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0093'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0090')),

-- Pré-requisito de Arquitetura de Processadores Digitais
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0177'), (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0090'));

SELECT
    materia_principal.nome_materia AS "Matéria",
    pre_requisito.nome_materia AS "Pré-Requisito"
FROM
    PRE_REQUISITO AS p
        JOIN
    MATERIAS AS materia_principal ON p.cod_materia = materia_principal.cod_mat
        JOIN
    MATERIAS AS pre_requisito ON p.cod_pre_requisito = pre_requisito.cod_mat;

INSERT INTO TURMA (cod_materia, semestre_oferta, ano_oferta, numero_vagas, horario, local_sala, id_campus) VALUES
-- Turmas para CIC0002 - FUNDAMENTOS TEÓRICOS DA COMPUTAÇÃO
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0002'), '2025.2', 2025, 50, '24T45', 'PJC BT 077', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0002'), '2025.2', 2025, 50, '35M12', 'PAT AT 036', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0002'), '2025.2', 2025, 50, '24N34', 'A definir', 1),

-- Turmas para CIC0004 - ALGORITMOS E PROGRAMAÇÃO DE COMPUTADORES
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0004'), '2025.2', 2025, 45, '235M12', 'PJC BT 036', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0004'), '2025.2', 2025, 45, '3M12 56M34', 'PJC BT 068', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0004'), '2025.2', 2025, 45, '235T45', 'PJC BT 021', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0004'), '2025.2', 2025, 50, '2T45 4T2345', '2T45(PJC BT 076) 4T4523(BSA S A1 16/37)', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0004'), '2025.2', 2025, 45, '246T23', 'PJC BT 028', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0004'), '2025.2', 2025, 46, '345N12', 'PJC BT 060', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0004'), '2025.2', 2025, 45, '2N12 4N1234', '4N1234(BSA S A1 16/37) 2N12(PJC BT 028)', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0004'), '2025.2', 2025, 70, '246T23 (18/08/2025 - 15/12/2025)', 'FCTE - I9 / I10 / I10', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0004'), '2025.2', 2025, 70, '35M5 3T1 5T145 (18/08/2025 - 15/12/2025)', 'FCTE - MOCAP / MOCAP / MOCAP / S9', 1),
((SELECT cod_mat FROM MATERias WHERE cod_disciplina = 'CIC0004'), '2025.2', 2025, 70, '35M12 2T45 (18/08/2025 - 15/12/2025)', 'FCTE - S10 / S9', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0004'), '2025.2', 2025, 70, '356M5 356T1 (18/08/2025 - 15/12/2025)', 'FCTE - S10', 1),

-- Turmas para CIC0090 - ESTRUTURAS DE DADOS
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0090'), '2025.2', 2025, 50, '35T23', 'BSA S A1 16/37', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0090'), '2025.2', 2025, 45, '46M34', '6M34(BSA S A1 16/37) 4M34(PJC BT 101)', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0090'), '2025.2', 2025, 30, '35M34', 'PJC BT 069', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0090'), '2025.2', 2025, 46, '35N12', 'PJC BT 053', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0090'), '2025.2', 2025, 46, '35N12', 'BSA S A1 16/37', 1), -- Note: Horário repetido, mas local diferente
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0090'), '2025.2', 2025, 40, '24M34', '2M34(PJC BT 125) 4M34(PJC BT 116)', 1),

-- Turmas para CIC0197 - TECNICAS DE PROGRAMAÇÃO 1
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0197'), '2025.2', 2025, 50, '35N34', 'PAT AT 076', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0197'), '2025.2', 2025, 50, '35M34', 'PAT AT 156', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0197'), '2025.2', 2025, 50, '35M34', 'PJC BT 133', 1), -- Note: Horário repetido, mas local diferente

-- Turma para CIC0005 - FORMAÇÃO DOCENTE EM COMPUTAÇÃO
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0005'), '2025.2', 2025, 80, '35N34', '5N34(BSA N AT 09/41) 3N34(BSA N A1 22/4', 1),

-- Turmas para CIC0093 - LINGUAGENS DE PROGRAMACAO
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0093'), '2025.2', 2025, 60, '24M12', 'A Definir', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0093'), '2025.2', 2025, 60, '46N12', 'A Definir', 1),

-- Turmas para CIC0182 - LÓGICA COMPUTACIONAL 1
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0182'), '2025.2', 2025, 50, '24T45', 'PJC BT 061', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0182'), '2025.2', 2025, 50, '24N34', 'PJC BT 012', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0182'), '2025.2', 2025, 50, '56M34', 'A Definir', 1);

UPDATE MATERIAS
SET cod_disciplina = 'EST0023'
WHERE cod_disciplina = 'EST0022';


INSERT INTO TURMA (cod_materia, semestre_oferta, ano_oferta, numero_vagas, horario, local_sala, id_campus) VALUES
-- Turmas para PAD0028 - ORGANIZAÇÃO DA EDUCAÇÃO BRASILEIRA
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2025.2', 2025, 45, '4T2345', 'BT9/13', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2025.2', 2025, 45, '2N1234', 'FE5S8', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2025.2', 2025, 45, '6N1234', 'FE5S9', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2025.2', 2025, 45, '5T2345', 'FE5S7', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2025.2', 2025, 45, '6N1234', 'FE5S8', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2025.2', 2025, 45, '35N12', 'FE5S9', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2025.2', 2025, 45, '6M1234', 'FE5S10', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2025.2', 2025, 45, '6N1234', 'FE5S11', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2025.2', 2025, 45, '6M1234', 'FE5S9', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2025.2', 2025, 45, '35N34', 'FE5S9', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2025.2', 2025, 45, '2T2345', 'FE5S8', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2025.2', 2025, 45, '2N1234', 'FE5S7', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2025.2', 2025, 45, '3M1234', 'FE5S5', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2025.2', 2025, 45, '24M34', 'FE510', 1),

-- Turmas para TEF0011 - PSICOLOGIA DA EDUCAÇÃO
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'TEF0011'), '2025.2', 2025, 45, '2N1234', 'FE5S10', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'TEF0011'), '2025.2', 2025, 45, '3M1234', 'FE5S10', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'TEF0011'), '2025.2', 2025, 45, '5T2345', 'FE5S10', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'TEF0011'), '2025.2', 2025, 45, '4M1234', 'BT9/13', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'TEF0011'), '2025.2', 2025, 45, '4N1234', 'FE5S09', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'TEF0011'), '2025.2', 2025, 45, '2T2345', 'FE5S5', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'TEF0011'), '2025.2', 2025, 45, '6T2345', 'FE5S10', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'TEF0011'), '2025.2', 2025, 45, '4T2345', 'FE5S9', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'TEF0011'), '2025.2', 2025, 45, '2M1234', 'FE5S9', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'TEF0011'), '2025.2', 2025, 45, '6N1234', 'FE5S10', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'TEF0011'), '2025.2', 2025, 45, '5N1234', 'FE5S10', 1),

-- Turmas para MAT0025 - CÁLCULO 1
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0025'), '2025.2', 2025, 40, '5N1234 6N12 (18/08/2025 - 15/12/2025)', 'SALA AT-48/22 (UAC)/FUP', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0025'), '2025.2', 2025, 36, '246T23', 'ICC ASS 415/10', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0025'), '2025.2', 2025, 32, '2N12 35N34', 'ICC ASS 421/10', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0025'), '2025.2', 2025, 71, '246M12', '2M12(ICC ANF.12) 46M12(ICC ANF.19)', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0025'), '2025.2', 2025, 77, '235M34', '2M34(ICC ANF. 4) 35M34(ICC ANF.13)', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0025'), '2025.2', 2025, 80, '235M34', '3M34(ICC ANF. 3) 2M34(ICC ANF. 4) 5M34(ICC ANF.16)', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0025'), '2025.2', 2025, 69, '2N12 35N34', '2N12(ICC ANF.12) 35N34(ICC ANF.14)', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0025'), '2025.2', 2025, 69, '2N12 35N34', '2N12(ICC ANF.12) 35N34(ICC ANF. 6)', 1),

-- Turmas para MAT0031 - INTRODUCAO A ALGEBRA LINEAR
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0031'), '2025.2', 2025, 65, '24T45', 'ICC ANF.16', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0031'), '2025.2', 2025, 65, '46M34', 'ICC ANF.15', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0031'), '2025.2', 2025, 65, '24T45', 'ICC ANF. 6', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0031'), '2025.2', 2025, 66, '24T45', 'ICC ANF.19', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0031'), '2025.2', 2025, 65, '35N12', 'ICC ANF.15', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0031'), '2025.2', 2025, 66, '24T45', 'ICC ANF.13', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0031'), '2025.2', 2025, 65, '35T45', 'ICC ANF. 6', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0031'), '2025.2', 2025, 65, '35T45', 'ICC ANF.13', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0031'), '2025.2', 2025, 65, '24T45', 'ICC ANF.17', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0031'), '2025.2', 2025, 65, '35T45', 'ICC ANF. 5', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0031'), '2025.2', 2025, 65, '35N12', 'ICC ANF. 6', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0031'), '2025.2', 2025, 110, '24M34 (18/08/2025 - 15/12/2025)', 'FCTE - S1', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0031'), '2025.2', 2025, 110, '46T23 (18/08/2025 - 15/12/2025)', 'FCTE - S1', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0031'), '2025.2', 2025, 110, '35M12 (18/08/2025 - 15/12/2025)', 'FCTE - S2', 1),

-- Turmas para MAT0026 - CÁLCULO 2
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0026'), '2025.2', 2025, 110, '235T23 (18/08/2025 - 15/12/2025)', 'FCTE - S4', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0026'), '2025.2', 2025, 60, '235M34', '2M34(BSA N AT 09/41) 3M34(ANF. 2) 5M34(ANF. 4)', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0026'), '2025.2', 2025, 60, '246T23', 'ICC ANF. 7', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0026'), '2025.2', 2025, 60, '235M34', 'ICC ANF. 7', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0026'), '2025.2', 2025, 65, '235M12', 'ICC ANF. 2', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0026'), '2025.2', 2025, 70, '235M34', 'ICC ANF.17', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0026'), '2025.2', 2025, 69, '235M34', '2M34(BSA N A1 29/41) 35M34(ICC ANF. 6)', 1),

-- Turmas para EST0023 - PROBABILIDADE E ESTATÍSTICA
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'EST0023'), '2025.2', 2025, 75, '24M12', 'BSA N A1 49/41', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'EST0023'), '2025.2', 2025, 75, '24M12', 'BSA N AT 58/41', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'EST0023'), '2025.2', 2025, 75, '46M12', 'BSA N AT 39/41', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'EST0023'), '2025.2', 2025, 75, '24M34', 'BSA N A1 09/41', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'EST0023'), '2025.2', 2025, 75, '46M34', 'BSA N A1 60/41', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'EST0023'), '2025.2', 2025, 70, '24T23', 'BSA N A1 63/11', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'EST0023'), '2025.2', 2025, 75, '24T23', 'BSA N A1 09/41', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'EST0023'), '2025.2', 2025, 75, '46T23', 'BSA N A1 60/41', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'EST0023'), '2025.2', 2025, 75, '24T45', '4T45(BSA N A1 60/41) 2T45(BSA N A1 58/41)', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'EST0023'), '2025.2', 2025, 75, '24N12', 'BSA N A1 09/41', 1),
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'EST0023'), '2025.2', 2025, 75, '24N12', 'BSA N A1 60/41', 1),

-- Turma para CIC0177 - ARQUITETURA DE PROCESSADORES DIGITAIS
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0177'), '2025.2', 2025, 40, '35N12', 'PJC BT 085', 1),

-- Turma para CIC0206 - MÉTODOS DE PESQUISA NA LICENCIATURA EM COMPUTAÇÃO
((SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0206'), '2025.2', 2025, 40, '2N12', 'PJC BT 068', 1);

--Select de matérias e turmas
SELECT
    t.id_turma,
    m.cod_disciplina,
    m.nome_materia,
    t.semestre_oferta,
    t.numero_vagas,
    t.horario,
    t.local_sala
FROM
    TURMA AS t
        JOIN
    MATERIAS AS m ON t.cod_materia = m.cod_mat
ORDER BY
    m.cod_disciplina, t.id_turma;

INSERT INTO ALUNO (matricula, cpf, nome_completo, data_nascimento, nacionalidade, semestre_ingresso, email_pessoal, email_institucional, senha, cod_curso) VALUES
('240011890', '11122233344', 'Ana Beatriz Costa', '2005-08-20', 'Brasileira', '2024.1', 'anabeatriz@email.com', '240011890@aluno.unb.br', 'senha123', (SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)')),
('240022789', '22233344455', 'Carlos Eduardo Martins', '2006-02-10', 'Brasileira', '2024.1', 'cadu.martins@email.com', '240022789@aluno.unb.br', 'senha123', (SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)')),
('240033678', '33344455566', 'Mariana Oliveira Lima', '2005-11-30', 'Brasileira', '2024.1', 'mari.lima@email.com', '240033678@aluno.unb.br', 'senha123', (SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)')),
('240055432', '55566677788', 'Lucas Ferreira Alves', '2006-03-12', 'Brasileira', '2024.1', 'lucas.alves@email.com', '240055432@aluno.unb.br', 'senha123', (SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)')),
('240044567', '44455566677', 'Sophie Dubois', '2006-01-25', 'Canadense', '2024.1', 'sophie.dubois@email.com', '240044567@aluno.unb.br', 'senha123', (SELECT cod_curso FROM CURSO WHERE nome_curso = 'Computação (Licenciatura)'));

INSERT INTO ALUNO_ESTRANGEIRO (matricula, passaporte, visto, pais_origem) VALUES
    ('240044567', 'CA9876543', 'Estudante V-1', 'Canadá');

select * from aluno;

INSERT INTO HISTORICO_ESCOLAR (matricula_aluno, cod_materia, semestre_conclusao, ano_conclusao, nota_final, status_conclusao) VALUES
-- Histórico da Ana Beatriz (1º e 2º semestres)
('240011890', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0004'), '2024.1', 2024, 9.5, 'Aprovado'),
('240011890', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0005'), '2024.1', 2024, 8.0, 'Aprovado'),
('240011890', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2024.1', 2024, 8.5, 'Aprovado'),
('240011890', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0002'), '2024.2', 2024, 7.5, 'Aprovado'),
('240011890', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0090'), '2024.2', 2024, 9.0, 'Aprovado'),
('240011890', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0025'), '2024.2', 2024, 8.0, 'Aprovado'),
('240011890', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'TEF0011'), '2024.2', 2024, 8.5, 'Aprovado'),

-- Histórico do Carlos (1º semestre)
('240022789', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0004'), '2024.1', 2024, 7.0, 'Aprovado'),
('240022789', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0005'), '2024.1', 2024, 7.5, 'Aprovado'),
('240022789', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2024.1', 2024, 8.0, 'Aprovado'),

-- Histórico da Mariana (1º e 2º semestres)
('240033678', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0004'), '2024.1', 2024, 9.0, 'Aprovado'),
('240033678', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0005'), '2024.1', 2024, 9.5, 'Aprovado'),
('240033678', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2024.1', 2024, 8.5, 'Aprovado'),
('240033678', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0002'), '2024.2', 2024, 8.0, 'Aprovado'),
('240033678', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0090'), '2024.2', 2024, 8.5, 'Aprovado'),
('240033678', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0025'), '2024.2', 2024, 7.0, 'Aprovado'),
('240033678', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'TEF0011'), '2024.2', 2024, 9.0, 'Aprovado'),

-- Histórico do Lucas (1º semestre)
('240055432', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0004'), '2024.1', 2024, 8.0, 'Aprovado'),
('240055432', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0005'), '2024.1', 2024, 8.5, 'Aprovado'),
('240055432', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2024.1', 2024, 7.5, 'Aprovado'),

-- Histórico da Sophie (1º semestre)
('240044567', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0004'), '2024.1', 2024, 9.0, 'Aprovado'),
('240044567', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0005'), '2024.1', 2024, 8.0, 'Aprovado'),
('240044567', (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'PAD0028'), '2024.1', 2024, 9.5, 'Aprovado');

SELECT
    a.nome_completo,
    m.cod_disciplina,
    m.nome_materia,
    h.semestre_conclusao,
    h.nota_final,
    h.status_conclusao
FROM
    HISTORICO_ESCOLAR AS h
        JOIN
    ALUNO AS a ON h.matricula_aluno = a.matricula
        JOIN
    MATERIAS AS m ON h.cod_materia = m.cod_mat
ORDER BY
    a.nome_completo, h.semestre_conclusao;


-- Script Final para REGISTRO_INTERESSE
INSERT INTO REGISTRO_INTERESSE (matricula_aluno, id_turma, status_interesse, prioridade_interesse) VALUES
-- Alunos que fizeram só o 1º semestre (Carlos, Lucas, Sophie) -> Interesse em TODAS do 2º
('240022789', (SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0002') ORDER BY id_turma LIMIT 1), 'Registrado', 1),
('240022789', (SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0090') ORDER BY id_turma LIMIT 1), 'Registrado', 2),
('240022789', (SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0025') ORDER BY id_turma LIMIT 1), 'Registrado', 3),
('240022789', (SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'TEF0011') ORDER BY id_turma LIMIT 1), 'Registrado', 4),
('240055432', (SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0002') ORDER BY id_turma LIMIT 1), 'Registrado', 1),
('240055432', (SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0090') ORDER BY id_turma LIMIT 1), 'Registrado', 2),
('240055432', (SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0025') ORDER BY id_turma LIMIT 1), 'Registrado', 3),
('240055432', (SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'TEF0011') ORDER BY id_turma LIMIT 1), 'Registrado', 4),
('240044567', (SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0002') ORDER BY id_turma LIMIT 1), 'Registrado', 1),
('240044567', (SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0090') ORDER BY id_turma LIMIT 1), 'Registrado', 2),
('240044567', (SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0025') ORDER BY id_turma LIMIT 1), 'Registrado', 3),
('240044567', (SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'TEF0011') ORDER BY id_turma LIMIT 1), 'Registrado', 4),

-- Alunos que fizeram o 1º e 2º (Ana, Mariana) -> Interesse em matérias do 3º e 4º
-- Registros para Ana Beatriz (240011890)
('240011890', (SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0197') ORDER BY id_turma LIMIT 1), 'Registrado', 1),
('240011890', (SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0093') ORDER BY id_turma LIMIT 1), 'Registrado', 2),
('240011890', (SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'MAT0031') ORDER BY id_turma LIMIT 1), 'Registrado', 3),

-- Registros para Mariana Oliveira Lima (240033678)
('240033678', (SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0182') ORDER BY id_turma LIMIT 1), 'Registrado', 1),
('240033678', (SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0206') ORDER BY id_turma LIMIT 1), 'Registrado', 2),
('240033678', (SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0177') ORDER BY id_turma LIMIT 1), 'Registrado', 3);

--VIEW
CREATE OR REPLACE VIEW VW_DEMANDA_TURMAS AS
SELECT
    t.id_turma,
    t.semestre_oferta,
    m.cod_disciplina,
    m.nome_materia,
    d.sigla_departamento,
    t.horario,
    t.local_sala,
    t.numero_vagas,
    (SELECT count(*) FROM REGISTRO_INTERESSE ri WHERE ri.id_turma = t.id_turma) AS quantidade_interessados
FROM
    TURMA AS t
        JOIN
    MATERIAS AS m ON t.cod_materia = m.cod_mat
        JOIN
    DEPARTAMENTO AS d ON m.cod_departamento = d.cod_departamento
ORDER BY
    m.cod_disciplina, t.id_turma;

SELECT * FROM VW_DEMANDA_TURMAS;

CREATE OR REPLACE PROCEDURE sp_registrar_interesse_com_verificacao(
    p_matricula_aluno VARCHAR(20),
    p_id_turma INT
)
    LANGUAGE plpgsql
AS $$
DECLARE
    v_cod_materia INT;
    v_pre_requisitos_exigidos INT;
    v_pre_requisitos_cumpridos INT;
BEGIN
    SELECT cod_materia INTO v_cod_materia FROM TURMA WHERE id_turma = p_id_turma;

    SELECT count(*) INTO v_pre_requisitos_exigidos
    FROM PRE_REQUISITO
    WHERE cod_materia = v_cod_materia;

    SELECT count(*) INTO v_pre_requisitos_cumpridos
    FROM PRE_REQUISITO pr
             JOIN HISTORICO_ESCOLAR he ON pr.cod_pre_requisito = he.cod_materia
    WHERE pr.cod_materia = v_cod_materia
      AND he.matricula_aluno = p_matricula_aluno
      AND he.status_conclusao = 'Aprovado';

    IF v_pre_requisitos_cumpridos >= v_pre_requisitos_exigidos THEN
        INSERT INTO REGISTRO_INTERESSE (matricula_aluno, id_turma, status_interesse)
        VALUES (p_matricula_aluno, p_id_turma, 'Registrado');
    ELSE
        RAISE EXCEPTION 'O aluno % não cumpriu todos os pré-requisitos para a matéria %.', p_matricula_aluno, (SELECT nome_materia FROM MATERIAS WHERE cod_mat = v_cod_materia);
    END IF;
END;
$$;


ALTER TABLE ALUNO ADD COLUMN foto BYTEA;

SELECT id_turma FROM TURMA WHERE cod_materia = (SELECT cod_mat FROM MATERIAS WHERE cod_disciplina = 'CIC0197') LIMIT 1;

