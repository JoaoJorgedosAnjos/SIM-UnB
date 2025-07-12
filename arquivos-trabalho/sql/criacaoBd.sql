CREATE DATABASE unb_database;

-- 1. Tabela CAMPUS
CREATE TABLE CAMPUS (
                        id_campus SERIAL PRIMARY KEY,
                        nome_campus VARCHAR(255) NOT NULL UNIQUE,
                        endereco_campus VARCHAR(255)
);

-- 2. Tabela UNIDADE_ACADEMICA
CREATE TABLE UNIDADE_ACADEMICA (
                                   id_unidade SERIAL PRIMARY KEY,
                                   nome_unidade VARCHAR(255) NOT NULL UNIQUE,
                                   sigla_unidade VARCHAR(10) UNIQUE,
                                   tipo_unidade VARCHAR(20) NOT NULL CHECK (tipo_unidade IN ('Instituto', 'Faculdade')),
                                   id_campus INT,
                                   FOREIGN KEY (id_campus) REFERENCES CAMPUS(id_campus)
);

-- 3. Tabela DEPARTAMENTO
CREATE TABLE DEPARTAMENTO (
                              cod_departamento SERIAL PRIMARY KEY,
                              nome_departamento VARCHAR(255) NOT NULL UNIQUE,
                              id_unidade INT NOT NULL,
                              FOREIGN KEY (id_unidade) REFERENCES UNIDADE_ACADEMICA(id_unidade)
);

-- 4. Tabela CURSO
CREATE TABLE CURSO (
                       cod_curso SERIAL PRIMARY KEY,
                       nome_curso VARCHAR(255) NOT NULL UNIQUE,
                       cod_departamento INT NOT NULL,
                       nivel_curso VARCHAR(20) NOT NULL DEFAULT 'Graduação' CHECK (nivel_curso IN ('Graduação', 'Mestrado', 'Doutorado')),
                       FOREIGN KEY (cod_departamento) REFERENCES DEPARTAMENTO(cod_departamento)
);

-- 5. Tabela MATERIAS
CREATE TABLE MATERIAS (
                          cod_mat SERIAL PRIMARY KEY,
                          nome_materia VARCHAR(255) NOT NULL UNIQUE,
                          horas INT NOT NULL CHECK (horas > 0)
);

-- 6. Tabela TURMA
CREATE TABLE TURMA (
                       id_turma SERIAL PRIMARY KEY,
                       cod_materia INT NOT NULL,
                       semestre_oferta VARCHAR(10) NOT NULL, -- Ex: "2024.1"
                       ano_oferta INT NOT NULL,
                       numero_vagas INT NOT NULL CHECK (numero_vagas >= 0),
                       horario VARCHAR(100) NOT NULL,
                       local_sala VARCHAR(50) NOT NULL,
                       id_campus INT NOT NULL,
                       FOREIGN KEY (cod_materia) REFERENCES MATERIAS(cod_mat),
                       FOREIGN KEY (id_campus) REFERENCES CAMPUS(id_campus),
                       UNIQUE (cod_materia, semestre_oferta, ano_oferta, horario, local_sala)
);

-- 7. Tabela ALUNO
CREATE TABLE ALUNO (
                       matricula VARCHAR(20) PRIMARY KEY,
                       cpf VARCHAR(11) UNIQUE NOT NULL,
                       nome_completo VARCHAR(255) NOT NULL,
                       data_nascimento DATE NOT NULL,
                       nacionalidade VARCHAR(50) NOT NULL,
                       semestre_ingresso VARCHAR(10) NOT NULL,
                       email_pessoal VARCHAR(255) NOT NULL,
                       email_institucional VARCHAR(255) UNIQUE NOT NULL,
                       senha VARCHAR(255) NOT NULL,
                       cod_curso INT NOT NULL,
                       FOREIGN KEY (cod_curso) REFERENCES CURSO(cod_curso)
);

-- 8. Tabela ALUNO_ESTRANGEIRO
CREATE TABLE ALUNO_ESTRANGEIRO (
                                   matricula VARCHAR(20) PRIMARY KEY,
                                   passaporte VARCHAR(50) UNIQUE NOT NULL,
                                   visto VARCHAR(50) NOT NULL,
                                   pais_origem VARCHAR(50) NOT NULL,
                                   FOREIGN KEY (matricula) REFERENCES ALUNO(matricula)
);

-- 9. Tabela GRADE_CURRICULAR
CREATE TABLE GRADE_CURRICULAR (
                                  cod_curso INT NOT NULL,
                                  cod_materia INT NOT NULL,
                                  semestre_sugerido INT,
                                  tipo_materia VARCHAR(20) NOT NULL CHECK (tipo_materia IN ('Obrigatória', 'Optativa', 'Eletiva')),
                                  carga_horaria_sugerida INT,
                                  PRIMARY KEY (cod_curso, cod_materia),
                                  FOREIGN KEY (cod_curso) REFERENCES CURSO(cod_curso),
                                  FOREIGN KEY (cod_materia) REFERENCES MATERIAS(cod_mat)
);

-- 10. Tabela PRE_REQUISITO
CREATE TABLE PRE_REQUISITO (
                               cod_materia INT NOT NULL,
                               cod_pre_requisito INT NOT NULL,
                               PRIMARY KEY (cod_materia, cod_pre_requisito),
                               FOREIGN KEY (cod_materia) REFERENCES MATERIAS(cod_mat),
                               FOREIGN KEY (cod_pre_requisito) REFERENCES MATERIAS(cod_mat),
                               CHECK (cod_materia != cod_pre_requisito)
);

-- 11. Tabela REGISTRO_INTERESSE
CREATE TABLE REGISTRO_INTERESSE (
                                    id_registro_interesse SERIAL PRIMARY KEY,
                                    matricula_aluno VARCHAR(20) NOT NULL,
                                    id_turma INT NOT NULL,
                                    data_registro_interesse TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                                    status_interesse VARCHAR(50) NOT NULL DEFAULT 'Registrado' CHECK (status_interesse IN ('Registrado', 'Em Processamento', 'Alocado', 'Lista de Espera', 'Indeferido')),
                                    prioridade_interesse INT CHECK (prioridade_interesse >= 1 AND prioridade_interesse <= 5),
                                    UNIQUE (matricula_aluno, id_turma),
                                    FOREIGN KEY (matricula_aluno) REFERENCES ALUNO(matricula),
                                    FOREIGN KEY (id_turma) REFERENCES TURMA(id_turma)
);

-- 12. Tabela HISTORICO_ESCOLAR
CREATE TABLE HISTORICO_ESCOLAR (
                                   id_historico_item SERIAL PRIMARY KEY,
                                   matricula_aluno VARCHAR(20) NOT NULL,
                                   cod_materia INT NOT NULL,
                                   id_turma_origem INT,
                                   semestre_conclusao VARCHAR(10) NOT NULL,
                                   ano_conclusao INT NOT NULL,
                                   nota_final DECIMAL(4,2),
                                   status_conclusao VARCHAR(50) NOT NULL,
                                   data_registro_historico TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                                   CONSTRAINT chk_status_conclusao CHECK (status_conclusao IN (
                                                                                               'Aprovado', 'Reprovado por Nota', 'Reprovado por Falta', 'Aproveitamento', 'Dispensa', 'Trancamento'
                                       )),
                                   UNIQUE (matricula_aluno, cod_materia, semestre_conclusao),
                                   FOREIGN KEY (matricula_aluno) REFERENCES ALUNO(matricula),
                                   FOREIGN KEY (cod_materia) REFERENCES MATERIAS(cod_mat),
                                   FOREIGN KEY (id_turma_origem) REFERENCES TURMA(id_turma)
);

