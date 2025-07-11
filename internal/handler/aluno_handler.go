package handler

import (
	"encoding/json"
	"net/http"
	"io/ioutil"

	"github.com/JoaoJorgedosAnjos/sistema-de-interesse-de-matricula-UnB/internal/domain"
	"github.com/JoaoJorgedosAnjos/sistema-de-interesse-de-matricula-UnB/internal/repository"
	"github.com/go-chi/chi/v5"
)

type AlunoHandler struct {
	repo *repository.AlunoRepository
}

func NewAlunoHandler(repo *repository.AlunoRepository) *AlunoHandler {
	return &AlunoHandler{repo: repo}
}

// @Summary      Lista todos os alunos
// @Description  Retorna uma lista com todos os alunos cadastrados no banco de dados
// @Tags         Alunos
// @Accept       json
// @Produce      json
// @Success      200  {array}   domain.Aluno
// @Failure      500  {object}  map[string]string
// @Router       /alunos [get]
func (h *AlunoHandler) GetAllAlunos(w http.ResponseWriter, r *http.Request) {
	alunos, err := h.repo.FindAll()
	if err != nil {
		http.Error(w, "Erro ao buscar alunos: "+err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(alunos)
}

// @Summary      Busca um aluno pela matrícula
// @Description  Retorna os detalhes de um único aluno com base na sua matrícula
// @Tags         Alunos
// @Accept       json
// @Produce      json
// @Param        matricula  path      string  true  "Matrícula do Aluno"
// @Success      200        {object}  domain.Aluno
// @Failure      400        {object}  map[string]string
// @Failure      404        {object}  map[string]string
// @Router       /alunos/{matricula} [get]
func (h *AlunoHandler) GetAlunoByMatricula(w http.ResponseWriter, r *http.Request) {
	matricula := chi.URLParam(r, "matricula")
	if matricula == "" {
		http.Error(w, "Matrícula é obrigatória", http.StatusBadRequest)
		return
	}

	aluno, err := h.repo.FindByID(matricula)
	if err != nil {
		http.Error(w, "Aluno não encontrado: "+err.Error(), http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(aluno)
}

// @Summary      Cria um novo aluno
// @Description  Cria um novo aluno com base nos dados enviados em JSON
// @Tags         Alunos
// @Accept       json
// @Produce      json
// @Param        aluno  body      domain.Aluno  true  "Dados do Aluno para Criar"
// @Success      201    {object}  domain.Aluno
// @Failure      400    {object}  map[string]string
// @Failure      500    {object}  map[string]string
// @Router       /alunos [post]
func (h *AlunoHandler) CreateAluno(w http.ResponseWriter, r *http.Request) {
	var aluno domain.Aluno

	err := json.NewDecoder(r.Body).Decode(&aluno)
	if err != nil {
		http.Error(w, "Erro ao decodificar JSON: "+err.Error(), http.StatusBadRequest)
		return
	}

	novoAluno, err := h.repo.Create(aluno)
	if err != nil {
		http.Error(w, "Erro ao criar aluno: "+err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(novoAluno)
}

// @Summary      Atualiza um aluno existente
// @Description  Atualiza os dados de um aluno com base na sua matrícula
// @Tags         Alunos
// @Accept       json
// @Produce      json
// @Param        matricula  path      string        true  "Matrícula do Aluno"
// @Param        aluno      body      domain.Aluno  true  "Dados do Aluno para Atualizar"
// @Success      200        {object}  domain.Aluno
// @Failure      400        {object}  map[string]string
// @Failure      500        {object}  map[string]string
// @Router       /alunos/{matricula} [put]
func (h *AlunoHandler) UpdateAluno(w http.ResponseWriter, r *http.Request) {
	matricula := chi.URLParam(r, "matricula")
	if matricula == "" {
		http.Error(w, "Matrícula é obrigatória", http.StatusBadRequest)
		return
	}

	var aluno domain.Aluno
	err := json.NewDecoder(r.Body).Decode(&aluno)
	if err != nil {
		http.Error(w, "Erro ao decodificar JSON: "+err.Error(), http.StatusBadRequest)
		return
	}

	alunoAtualizado, err := h.repo.Update(matricula, aluno)
	if err != nil {
		http.Error(w, "Erro ao atualizar aluno: "+err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(alunoAtualizado)
}

// @Summary      Apaga um aluno
// @Description  Apaga um aluno do banco de dados com base na sua matrícula
// @Tags         Alunos
// @Accept       json
// @Produce      json
// @Param        matricula  path      string  true  "Matrícula do Aluno"
// @Success      204        {object}  nil
// @Failure      400        {object}  map[string]string
// @Failure      500        {object}  map[string]string
// @Router       /alunos/{matricula} [delete]
func (h *AlunoHandler) DeleteAluno(w http.ResponseWriter, r *http.Request) {
	matricula := chi.URLParam(r, "matricula")
	if matricula == "" {
		http.Error(w, "Matrícula é obrigatória", http.StatusBadRequest)
		return
	}

	err := h.repo.Delete(matricula)
	if err != nil {
		http.Error(w, "Erro ao apagar aluno: "+err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

// @Summary      Faz o upload de uma foto para um aluno
// @Description  Recebe um arquivo de imagem e o salva para o aluno com a matrícula especificada
// @Tags         Alunos
// @Accept       multipart/form-data
// @Produce      json
// @Param        matricula  path      string  true  "Matrícula do Aluno"
// @Param        foto       formData  file    true  "Arquivo de foto para upload"
// @Success      200        {object}  map[string]string
// @Failure      400        {object}  map[string]string
// @Failure      500        {object}  map[string]string
// @Router       /alunos/{matricula}/foto [post]
func (h *AlunoHandler) UploadFotoAluno(w http.ResponseWriter, r *http.Request) {
	matricula := chi.URLParam(r, "matricula")
	if matricula == "" {
		http.Error(w, "Matrícula é obrigatória", http.StatusBadRequest)
		return
	}

	r.ParseMultipartForm(10 << 20)

	file, _, err := r.FormFile("foto")
	if err != nil {
		http.Error(w, "Erro ao recuperar o arquivo: "+err.Error(), http.StatusBadRequest)
		return
	}
	defer file.Close()

	fileBytes, err := ioutil.ReadAll(file)
	if err != nil {
		http.Error(w, "Erro ao ler o arquivo: "+err.Error(), http.StatusInternalServerError)
		return
	}

	err = h.repo.UpdateFoto(matricula, fileBytes)
	if err != nil {
		http.Error(w, "Erro ao salvar a foto no banco de dados: "+err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Foto enviada com sucesso!"})
}