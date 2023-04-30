module ExternalVideoImport
  module MetadataProcessing
    class VideoCreator
      def self.create_video(attributes)
        ::Video.create!(attributes)
      end
    end
  end
end
