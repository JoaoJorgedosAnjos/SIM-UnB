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

--erro pois nao tem o pre requisito
CALL sp_registrar_interesse_com_verificacao('240022789', 27);

--correto
CALL sp_registrar_interesse_com_verificacao('240011890', 22);

--http://localhost:8080/swagger/index.html#/