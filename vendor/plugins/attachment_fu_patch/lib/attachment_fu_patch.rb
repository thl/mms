# AttachmentFuPatch
require 'fileutils'
module Technoweenie # :nodoc:
  module AttachmentFu # :nodoc:    
    module ClassMethods
      @@content_types = Image::VALID_MIME_TYPES
      @@supported_raw_formats = ['nef', 'dng', 'cr2']

      mattr_reader :content_types, :supported_raw_formats
      
      def convert_if_unsupported(file, filename = file)
        ext = File.extname(filename) # on purpose not using file since tempfile may loose extension.
        ext = ext[1...ext.size].downcase if !ext.blank?
        if supported_raw_formats.include? ext
          begin
            # Log the failure to load the image.  This should match ::Magick::ImageMagickError
            # but that would cause acts_as_attachment to require rmagick.
            message = `ufraw-batch '#{file}' '--out-path=#{Technoweenie::AttachmentFu.tempfile_path}'`
            base_name = "#{File.basename(file,'.*')}.ppm"
            original_temp = File.expand_path(File.join(Technoweenie::AttachmentFu.tempfile_path, base_name))
            raise "Format for #{self.filename} could not be processed: #{message}" unless File.exists?(original_temp)
            new_temp = copy_to_temp_file(original_temp, "#{rand Time.now.to_i}_#{base_name}")
            FileUtils::rm original_temp
            return new_temp
          rescue
            logger.debug("Exception working with image: #{$!}")
            return file
          end
        else
          return file
        end
      end
    end
    
    module InstanceMethods
      # This method handles the uploaded file object.  If you set the field name to uploaded_data, you don't need
      # any special code in your controller.
      #
      #   <% form_for :attachment, :html => { :multipart => true } do |f| -%>
      #     <p><%= f.file_field :uploaded_data %></p>
      #     <p><%= submit_tag :Save %>
      #   <% end -%>
      #
      #   @attachment = Attachment.create! params[:attachment]
      #
      # TODO: Allow it to work with Merb tempfiles too.
      alias_method :__uploaded_data=, :uploaded_data=
      
      def uploaded_data=(file_data)
        self.__uploaded_data=file_data
        if self.content_type=='application/octet-stream'
          self.content_type = Image::VALID_TYPES[FilenameUtils.extension_without_dot(self.filename).downcase]
        end
      end
      
      def temp_path=(file_data)
        self.temp_paths.unshift file_data
      end
      
      # Gets the thumbnail name for a filename.  'foo.jpg' becomes 'foo_thumbnail.jpg'
      def thumbnail_name_for(thumbnail = nil)
        return filename if thumbnail.blank?
        "#{FilenameUtils.basename(filename)}_#{thumbnail}.jpg"
      end
      
      def convert_if_unsupported(file)
        self.class.convert_if_unsupported(file, self.filename)
      end
      
      def update_thumbnails
        if respond_to?(:process_attachment_with_processing) && thumbnailable? && !attachment_options[:thumbnails].blank? && parent_id.nil?
          temp_file = convert_if_unsupported(temp_path || create_temp_file)
          attachment_options[:thumbnails].each { |suffix, size| create_or_update_thumbnail(temp_file, suffix, *size) }
        end
        @temp_paths.clear
        @saved_attachment = nil
      end
      
      # Cleans up after processing.  Thumbnails are created, the attachment is stored to the backend, and the temp_paths are cleared.
      def after_process_attachment
        if @saved_attachment
          save_to_storage
          update_thumbnails
          callback :after_attachment_saved
        end
      end
      
      def date_time_original
        date_time_str = properties['exif:DateTimeOriginal']
        date_time_str = properties['tiff:timestamp'] if date_time_str.nil?
        if !date_time_str.blank?
          return DateTime.parse(date_time_str.split(":",3).join("-"))
        end
        return nil
      end
      
      def make
        make_str = properties['exif:Make']
        make_str = properties['tiff:make'] if make_str.nil?
        return make_str
      end
      
      def model
        model_str = properties['exif:Model']
        model_str = properties['tiff:model'] if model_str.nil?
        return model_str
      end
      
      private
      
      def properties
        @properties ||= nil
        if @properties.nil?
          with_image{|img| @properties = self.class.properties(img)  }
          @properties = {} if @properties.nil?
        end
        return @properties
      end
    end
    
    module Processors
      module RmagickProcessor        
        module ClassMethods
          def properties(img)
            img.get_exif_by_entry
            return img.properties
          end
        end
        
        protected
        
        # Performs the actual resizing operation for a thumbnail
        def resize_image(img, size)
          size = size.first if size.is_a?(Array) && size.length == 1 && !size.first.is_a?(Fixnum)
          quality = nil
          if size.is_a?(Fixnum) || (size.is_a?(Array) && size.first.is_a?(Fixnum))
            size = [size, size] if size.is_a?(Fixnum)
            img.thumbnail!(*size)
          else
            if size.is_a?(String)
              pos = size.index(':')
              if !pos.nil?
                quality = size[0...pos].to_i
                size = size[pos+1...size.size]
              end
              if size[size.size-1]==35
                size.downcase!
                pos = size.index('x')
                img.crop_resized!(size[0...pos].to_i, size[pos+1...size.size-1].to_i)
              else            
                img.change_geometry(size.to_s) { |cols, rows, image| image.resize!(cols<1 ? 1 : cols, rows<1 ? 1 : rows) }
              end
            end
          end
          img.strip! unless attachment_options[:keep_profile]
          data = img.to_blob do
            self.quality = quality if !quality.nil?
            self.format = 'JPG'
          end
          self.temp_path = write_to_temp_file(data)
        end
      end
    end
  end
end