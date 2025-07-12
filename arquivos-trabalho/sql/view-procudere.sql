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

--PROCEDURE

CREATE OR REPLACE PROCEDURE sp_cadastrar_aluno_com_historico(
    p_matricula VARCHAR(20),
    p_nome_completo VARCHAR(255),
    p_cpf VARCHAR(11),
    p_data_nascimento DATE,
    p_cod_curso INT
)
    LANGUAGE plpgsql
AS $$
DECLARE
    v_materia_do_semestre RECORD;
BEGIN
    INSERT INTO ALUNO (
        matricula, cpf, nome_completo, data_nascimento, nacionalidade,
        semestre_ingresso, email_pessoal, email_institucional, senha, cod_curso
    ) VALUES (
                 p_matricula,
                 p_cpf,
                 p_nome_completo,
                 p_data_nascimento,
                 'Brasileira',
                 '2024.1',
                 'pessoal@email.com',
                 p_matricula || '@aluno.unb.br',
                 'senha123',
                 p_cod_curso
             );

    FOR v_materia_do_semestre IN
        SELECT cod_materia
        FROM GRADE_CURRICULAR
        WHERE cod_curso = p_cod_curso AND semestre_sugerido = 1
        LOOP
            INSERT INTO HISTORICO_ESCOLAR (
                matricula_aluno, cod_materia, semestre_conclusao, ano_conclusao, nota_final, status_conclusao
            ) VALUES (
                         p_matricula,
                         v_materia_do_semestre.cod_materia,
                         '2023.2',
                         2023,
                         8.5,
                         'Aprovado'
                     );
        END LOOP;
END;
$$;

CREATE OR REPLACE VIEW VW_ALUNO_HISTORICO AS
SELECT
    a.matricula,
    a.nome_completo,
    a.email_institucional,
    c.nome_curso,
    m.cod_disciplina,
    m.nome_materia,
    h.status_conclusao,
    h.nota_final,
    h.semestre_conclusao
FROM
    HISTORICO_ESCOLAR h
        JOIN
    ALUNO a ON h.matricula_aluno = a.matricula
        JOIN
    MATERIAS m ON h.cod_materia = m.cod_mat
        JOIN
    CURSO c ON a.cod_curso = c.cod_curso
ORDER BY
    a.nome_completo, h.semestre_conclusao;

CALL sp_cadastrar_aluno_com_historico(
        '240223307',
        'Luisa Bastos',
        '22233345467',
        '1998-07-08',
        2
     );

SELECT * FROM VW_ALUNO_HISTORICO WHERE matricula = '240223307';

CALL sp_cadastrar_aluno_com_historico(
        '240134477',
        'Mariana Alves',
        '33344415567',
        '2005-11-30',
        2 
     );

SELECT * FROM VW_ALUNO_HISTORICO WHERE matricula = '240134477';