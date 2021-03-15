# == Schema Information
#
# Table name: songs
#
#  id               :bigint           not null,
#  primary key
#  genre            :string
#  title            :string
#  artist           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  artist_2         :string
#  composer         :string
#  author           :string
#  date             :date
#  last_name_search :string
#  occur_count      :integer          default(0)
#  popularity       :integer          default(0)
#  active           :boolean          default(TRUE)
#  lyrics           :text
#
FactoryBot.define do
  factory :song do
    genre { "TANGO" }
    title { "La mentirosa" }
    artist { "Anibal Troilo" }
    artist_2 { "Jorge Casal" }
    composer { "Anselmo Aieta" }
    author { "Francisco García Jiménez" }
    date { "MyText" }
    popularity { "0" }
    active { true }
    lyrics do
      "Cuanto te amé,
              puedo decir que jamás otra mujer,
              podré querer como a vos. La juventud no volverá nunca más y a la ambición ya puedo dar el adiós. Qué tiempo aquel,
              hora fugaz que pasó,
              todo el valor de una pasión conocí. Cuanta feliz frase de amor escuché,
              que siempre yo,
              sumiso y fiel te creí.  Las caricias de tus manos,
              tus palabras de ternura,
              dejaron cruel amargura,
              porque nada fue verdad. Besos falsos de tu boca,
              juramentos,
              ilusiones,
              mataron mis ambiciones,
              sin un poco de piedad.  Pero,
              por el mal que vos me hiciste,
              solo dice mi alma triste,
              mentirosa,
              mentirosa. Todo lo que me has hecho pasar,
              penas,
              llanto,
              con otro lo has de pagar.  Ya encontrarás quien un amor fingirá entonces sí,
              vas querer sin mentir,
              has de ser vos la que al final llorará. Siempre de mi te acordarás al sufrir,
              ha de sangrar tu corazón al pensar,
              en todo el mal que hiciste a mi ilusión y hasta al morir,
              hasta el morir,
              mirarás los ojos del fantasma de tu traición."
    end
    last_name_search { "TROILO" }
  end

  factory :random_song do
    genre { Faker::Music.genre }
    title { Faker::Music::RockBand.song }
    artist { Faker::Name.name }
    artist_2 { Faker::Name.name }
    composer { Faker::Name.name }
    author { Faker::Name.name }
    date { Faker::Date.between(from: "1900-01-01", to: Date.today) }
    popularity { Faker::Number.between(from: 1, to: 100) }
    active { true }
    lyrics { Faker::Quote.famous_last_words }
    last_name_search { artist.last }
  end
end
