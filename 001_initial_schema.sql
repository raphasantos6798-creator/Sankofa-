-- Initial Sankofa Database Schema
-- Created: 2026-03-10

-- Table: usuarios (Teachers + Admin)
CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'professor',
    municipio VARCHAR(255),
    estado VARCHAR(2),
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_role CHECK (role IN ('professor', 'admin', 'coordenador', 'aluno'))
);

-- Table: alunos
CREATE TABLE IF NOT EXISTS alunos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    escola VARCHAR(255) NOT NULL,
    municipio VARCHAR(255) NOT NULL,
    estado VARCHAR(2) NOT NULL,
    ano_escolar VARCHAR(10),
    usuario_id INTEGER REFERENCES usuarios(id),
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: cursos
CREATE TABLE IF NOT EXISTS cursos (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT,
    categoria VARCHAR(100) NOT NULL,
    modulos INTEGER DEFAULT 0,
    tempo_estimado VARCHAR(50),
    criado_por INTEGER REFERENCES usuarios(id),
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_categoria CHECK (categoria IN ('historia_africa', 'diaspora', 'resistencia_negra', 'formacao_professor'))
);

-- Table: modulos
CREATE TABLE IF NOT EXISTS modulos (
    id SERIAL PRIMARY KEY,
    curso_id INTEGER NOT NULL REFERENCES cursos(id),
    numero INTEGER NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    conteudo TEXT,
    recursos JSON,
    duracao_minutos INTEGER,
    ordem INTEGER,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: progresso_aluno
CREATE TABLE IF NOT EXISTS progresso_aluno (
    id SERIAL PRIMARY KEY,
    aluno_id INTEGER NOT NULL REFERENCES alunos(id),
    modulo_id INTEGER NOT NULL REFERENCES modulos(id),
    percentual_completo INTEGER DEFAULT 0,
    completado BOOLEAN DEFAULT FALSE,
    data_inicio TIMESTAMP,
    data_conclusao TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(aluno_id, modulo_id)
);

-- Table: impacto (Dados em tempo real)
CREATE TABLE IF NOT EXISTS impacto (
    id SERIAL PRIMARY KEY,
    total_alunos INTEGER DEFAULT 0,
    total_municipios INTEGER DEFAULT 0,
    total_professores INTEGER DEFAULT 0,
    modulos_concluidos INTEGER DEFAULT 0,
    taxa_conclusao DECIMAL(5,2) DEFAULT 0.00,
    pl_progresso INTEGER DEFAULT 0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para performance
CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_usuarios_municipio ON usuarios(municipio);
CREATE INDEX idx_alunos_municipio ON alunos(municipio);
CREATE INDEX idx_alunos_usuario_id ON alunos(usuario_id);
CREATE INDEX idx_progresso_aluno_id ON progresso_aluno(aluno_id);
CREATE INDEX idx_progresso_modulo_id ON progresso_aluno(modulo_id);
CREATE INDEX idx_modulos_curso_id ON modulos(curso_id);
CREATE INDEX idx_cursos_categoria ON cursos(categoria);

-- Inserir dados iniciais de impacto
INSERT INTO impacto (total_alunos, total_municipios, total_professores, pl_progresso)
VALUES (1247, 34, 892, 72)
ON CONFLICT DO NOTHING;
