#
# Download all of the school board pdfs from source list
#
# Requires curl + xpdf pathed in local system
#

require "net/http"
require "uri"

def fetchFiles
  pdfList = open("schoolPdfs", 'r')
  pdfList.each do |line|
   system("curl -O "+line)
  end
  pdfList.close
end

def decodePdfs
 workingDir = '.'
 pdfs = Dir.glob("*.pdf")

 pdfs.each do |pdf|
   system("pdftotext -nopgbrk ./"+pdf)
 end

end

def createOrTossFile(someFilename)
  if !File.exist?(someFilename)
    system("touch #{someFilename}")
  elsif
    system("rm #{someFilename}")
    system("touch #{someFilename}")
  end
end

def buildSaneOutput
  #open the outFile
  createOrTossFile("data.json")
  outFile = open("data.json", 'w')

  #open all the inFiles
  inFiles=[]
  fname=[]

  workingDir = '.'
  txts = Dir.glob("*.txt")



  txts.each do |txt|


    inFiles<<File.new(txt)
    fname<<txt[0..-5]
  end

  schoolIterator=0
  outFile.write("{ \"Mathematics\":")
  showcomma=false
    outFile.write("{")#open school
  inFiles.each do |inFile|
    #p school.to_s+" #{schoolIterator}"
      outFile.write(",")  if showcomma

    outFile.write("\"#{fname[schoolIterator]}\":")

    inMath=false
    dataLine=false
    topicLine=false
    inFileIterator=0
    fileLines=inFile.readlines

    showcomma=true
    outFile.write("{")#open school

    fileLines.each do |line|




      if inMath && topicLine
        #break if line.include?("*")

        topicLine=false
        topic=line
        data=fileLines[inFileIterator+1]
        p topic.gsub(/\n/,"")
        p data.gsub(/\n/,"")
          outFile.write("\"#{topic.gsub(/\n/,"")}\":\"#{data.gsub(/\n/,"")}\"")#close line
      end

      if line=="Mathematics Assessments*\n"
        inMath=true
        topicLine=true
      end

      inFileIterator+=1

    end


    # inFile.each_line do |line|
    #   if line=="Mathematics Assessments*\n"
    #     p "found in #{fname[schoolIterator]}"
    #     dataLine=line
    #
    #   end
    #
    # end
      schoolIterator+=1
    # until line=="Mathematics Assessments*\n" do
    #
    #   p school
    #   begin
    #     p "seeking in #{fname[schoolIterator]}"
    #     lastline=line
    #     #Seek till we find math
    #     until line!=nil do
    #       line=school.gets
    #     end
    #       #break if they didn't have math in the file
    #     break if line==nil
    #     puts line
    #
    #
    #
    #   rescue
    #     puts "error reading lines from file"
    #     puts "last line = #{lastline} "
    #     p "school #{fname[schoolIterator]}"
    #   end
    # end

    # outFile.write("{\"#{dataLine}\":\n{")

  outFile.write("}")#close school
  end
  outFile.write("}")#close all
    outFile.write("}")#close all
  #cleanup
  inFiles.each do |inFile|
    inFile.close
  end

end

def cleanAscii

    txts.each do |txt|
      #clean it from any unicode chars
      system("iconv -c -f utf-8 -t ascii #{txt}")
      system("strings #{txt}>tmpfile")
      system("strings tmpfile>#{txt}")
    end

end


#fetchFiles
#decodePdfs
#cleanAscii
buildSaneOutput