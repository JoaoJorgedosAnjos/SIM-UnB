package database

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/jackc/pgx/v5"
)

func NewDB(databaseUrl string) *pgx.Conn {
	conn, err := pgx.Connect(context.Background(), databaseUrl)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Não foi possível conectar ao banco de dados: %v\n", err)
		os.Exit(1)
	}

	err = conn.Ping(context.Background())
	if err != nil {
		log.Fatalf("Ping ao banco de dados falhou: %v", err)
	}

	fmt.Println("Conectado ao PostgreSQL com sucesso!")
	return conn
}