require './models/site'

class Mangapanda < Site
  def parse
    @document = Nokogiri::HTML(open('http://www.mangapanda.com'))
    entries = Entry.all
    updated = []
    @document.css('a.chaptersrec').each do |link|
      *manga_name, current_chapter = link.content.split
      manga_name = manga_name.join(' ')
      stored_manga = entries.find{|e| e.name == manga_name}
      if !stored_manga.nil? && current_chapter.to_i > stored_manga.number.to_i
        if block_given?
          yield(stored_manga, current_chapter)
        end
      end
    end
  end
end
