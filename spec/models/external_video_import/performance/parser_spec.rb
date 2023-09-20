# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::Performance::Parser do
  fixtures :all

  describe "#parse" do
    # rubocop:disable RSpec/RepeatedDescription
    it "returns a performance with the correct attributes" do
      text = "Gianpiero Galdi & Lorena Tarantino - Krakus Aires Tango Festival 2019 4/5"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq(4)
      expect(performance.total).to eq(5)
    end

    it "returns a performance with the correct attributes" do
      text = "CORINA HERRERA e INES MUZZOPAPPA en Viva La Pepa Milonga dentro del LADY'S Tango (1/2)"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq(1)
      expect(performance.total).to eq(2)
    end

    it "returns a performance with the correct attributes" do
      text = "[ Milonga ] 2023.09.09 - Maja Petrovic & Marko Miljevic - Show.No.4"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq(4)
      expect(performance.total).to be_nil
    end

    it "returns a performance with the correct attributes" do
      text = "Agustina Piaggio & Carlitos Espinoza London Scottish House Performance 2"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq(2)
      expect(performance.total).to be_nil
    end

    it "returns a performance with the correct attributes" do
      text = "Michael Nadtochi y Elvira Lambo 14° Transylvania Tango Marathon 05.08.2023 1.4 Brasov Romania"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq(1)
      expect(performance.total).to eq(4)
    end

    it "returns a performance with the correct attributes" do
      text = "Carla Rossi y José Luis Salvo - Milonga Gente Amiga - 2022 (3 de 3)"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq(3)
      expect(performance.total).to eq(3)
    end

    it "returns a performance with the correct attributes" do
      text = "Andrés Molina & Natacha Lockwood - 04 - Milonga del 900 @ La Mandrilera"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq(4)
      expect(performance.total).to be_nil
    end

    it "returns a performance with the correct attributes" do
      text = "Sercan Yiğit & Zeynep Aktar, Tus Palabras y la Noche by Carlos Di Sarli #sultanstango '22. Part-2"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq(2)
      expect(performance.total).to be_nil
    end

    it "returns a performance with the correct attributes" do
      text = "Milonga TA-TAA! - Taunus, near Frankfurt, Germany (24. 6. 2023) ~ DJ Pepa Palazon #1"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq(1)
      expect(performance.total).to be_nil
    end

    it "returns a performance with the correct attributes" do
      text = "Sebastian Bolivar & Cynthia Palacios (29 Jun 2023): 2nd Dance"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq(2)
      expect(performance.total).to be_nil
    end

    it "returns a performance with the correct attributes" do
      text = "Carlos Espinoza & Noelia Hurtado. 4. PLANETANGO-XXI Tango Festival"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq(4)
      expect(performance.total).to be_nil
    end

    it "returns a performance with the correct attributes" do
      text = "Sebastián Missé and Andrea Reyero Aug 19 HK Milonga Mascarita #1"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq(1)
      expect(performance.total).to be_nil
    end

    it "returns a performance with the correct attributes" do
      text = "Georgia Priskou & Loukas Balokas - El Tigre Millan by Juan D'Arienzo, #sultanstango '22. Part -1-"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq(1)
      expect(performance.total).to be_nil
    end

    it "returns a performance with the correct attributes" do
      text = "Performance 1 Rocio Lequío und Bruno Tombari in Bamberg 2023"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq(1)
      expect(performance.total).to be_nil
    end

    it "returns a performance with the correct attributes" do
      text = "Noelia Hurtado y Carlitos Espinoza - 04"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq(4)
      expect(performance.total).to be_nil
    end

    it "returns a performance with the correct attributes" do
      text = "Juan Malizia & Manuela Rossi 1/3 (15th tanGOTOistanbul)"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq 1
      expect(performance.total).to eq 3
    end

    it "returns a performance with the correct attributes" do
      text = "Javier Rodriguez & Fatima Vitale 1/ 3 | 15th tango2istanbul"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq 1
      expect(performance.total).to eq 3
    end

    it "returns a performance with the correct attributes" do
      text = "Alexa Yepes & Edwin Espinoza l Maipo Juan D' Arienzol Puerto del tango l 2~5"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq 2
      expect(performance.total).to eq 5
    end

    it "returns a performance with the correct attributes" do
      text = "Analia vega & Marcelo Varela - 3-4 - 2023.05.11"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq 3
      expect(performance.total).to eq 4
    end

    it "returns a performance with the correct attributes" do
      text = "Mariano Otero y Alejandra Mantiñán 16°Tangofestivalvacanze in Puglia 22 07 2022 2 4"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq 2
      expect(performance.total).to eq 4
    end

    it "returns nil when performance date information is present" do
      text = "Cynthia Palacios y Sebastián Bolivar @ Practica Las Malevas 3/24/23"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance).to be_nil
    end

    it "returns nil when performance date information is present" do
      text = "A WEEK OF TANGO IN BALI - Tango in Paradise - Cultural Show 2-1 Leandro Palou & Maria Tsiatsiani"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance).to be_nil
    end

    it "returns nil when performance date information is present" do
      text = "Sabrina Masso & Federico Naveira en Milonga Malena \"COMO NINGUNA\"!!3/4"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)
      expect(performance.position).to eq 3
      expect(performance.total).to eq 4
    end

    it "returns nil when performance information is not present" do
      text = "Amazing performance by the great dancers"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)

      expect(performance).to be_nil
    end

    it "returns nil when performance information is invalid" do
      text = "Amazing performance 6 of 3 by the great dancers"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)

      expect(performance).to be_nil
    end

    it "returns nil when performance information is invalid" do
      text = "Deniz Arslan & Abdullah Aydin at 333"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)

      expect(performance).to be_nil
    end

    it "returns nil when performance information is invalid" do
      text = "13th Shanghai International Tango Festival Day 2 - Christian Marquez y Virginia Gomez 2"
      performance = ExternalVideoImport::Performance::Parser.new.parse(text:)

      expect(performance.position).to eq 2
      expect(performance.total).to be_nil
    end
    # rubocop:enable RSpec/RepeatedDescription
  end
end
