const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL
});

async function seedDatabase() {
  try {
    console.log('🌱 Iniciando seed do banco...');

    // Cursos padrão
    const cursos = [
      {
        titulo: 'História da África',
        descricao: 'Conhecendo as raízes e civilizações africanas',
        categoria: 'historia_africa',
        modulos: 5,
        tempo_estimado: '10 horas'
      },
      {
        titulo: 'A Diáspora Africana',
        descricao: 'O trajeto do povo africano pelo mundo',
        categoria: 'diaspora',
        modulos: 4,
        tempo_estimado: '8 horas'
      },
      {
        titulo: 'Resistência Negra',
        descricao: 'Lutas e vitórias do povo negro',
        categoria: 'resistencia_negra',
        modulos: 6,
        tempo_estimado: '12 horas'
      },
      {
        titulo: 'Formação de Professores',
        descricao: 'Como ensinar história afro-brasileira com impacto',
        categoria: 'formacao_professor',
        modulos: 8,
        tempo_estimado: '16 horas'
      }
    ];

    for (const curso of cursos) {
      const result = await pool.query(
        `INSERT INTO cursos (titulo, descricao, categoria, modulos, tempo_estimado, ativo)
         VALUES ($1, $2, $3, $4, $5, true)
         ON CONFLICT DO NOTHING`,
        [curso.titulo, curso.descricao, curso.categoria, curso.modulos, curso.tempo_estimado]
      );
    }

    console.log('✅ Seed concluído!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Erro no seed:', error);
    process.exit(1);
  }
}

seedDatabase();
