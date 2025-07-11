package handler

import (
	"fmt"
	"net/http"
	"runtime/debug"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	httpSwagger "github.com/swaggo/http-swagger/v2"
)

func NewRouter(alunoHandler *AlunoHandler, cursoHandler *CursoHandler, registroHandler *RegistroInteresseHandler) http.Handler {
	router := chi.NewRouter()

	router.Use(middleware.Logger)

	router.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("API do Projeto UnB no ar!"))
	})
	
	router.Get("/swagger/*", func(w http.ResponseWriter, r *http.Request) {
		defer func() {
			if r := recover(); r != nil {
				w.WriteHeader(http.StatusInternalServerError)
				w.Write([]byte(fmt.Sprintf("Ocorreu um pânico: %v\n", r)))
				w.Write(debug.Stack())
			}
		}()

		httpSwagger.Handler(httpSwagger.URL("doc.json")).ServeHTTP(w, r)
	})


	router.Route("/alunos", func(r chi.Router) {
		r.Post("/", alunoHandler.CreateAluno)
		r.Get("/", alunoHandler.GetAllAlunos)
		r.Route("/{matricula}", func(r chi.Router) {
			r.Get("/", alunoHandler.GetAlunoByMatricula)
			r.Post("/foto", alunoHandler.UploadFotoAluno)
			r.Put("/", alunoHandler.UpdateAluno)
			r.Delete("/", alunoHandler.DeleteAluno)
		})
	})

	router.Route("/cursos", func(r chi.Router) {
		r.Get("/", cursoHandler.GetAllCursos)
		r.Post("/", cursoHandler.CreateCurso)
		r.Route("/{id}", func(r chi.Router) {
			r.Get("/", cursoHandler.GetCursoByID)
			r.Put("/", cursoHandler.UpdateCurso)
			r.Delete("/", cursoHandler.DeleteCurso)
		})
	})

	router.Route("/interesses", func(r chi.Router) {
		r.Get("/", registroHandler.GetAll)
		r.Post("/", registroHandler.Create)
		r.Route("/{id}", func(r chi.Router) {
			r.Get("/", registroHandler.GetByID)
			r.Put("/", registroHandler.Update)
			r.Delete("/", registroHandler.Delete)
		})
	})

	return router
}