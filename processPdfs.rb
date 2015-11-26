#
# Download all of the school board pdfs from source list
#
# Requires curl + xpdf pathed in local system
#

require "net/http"
require "uri"

# Fetch the files listed in schoolPdfs via Curl and download them to pwd
def fetchFiles
  pdfList = open("schoolPdfs", 'r')
  pdfList.each do |line|
   system("curl -O "+line)
  end
  pdfList.close
end

# Using xpdf's pdftoText convert pdfs to text
def decodePdfs
 workingDir = '.'
 pdfs = Dir.glob("*.pdf")

 pdfs.each do |pdf|
   system("pdftotext -nopgbrk ./"+pdf)
 end

end

# Refresh the filesystem as required.
# if someFilename exist it will be deleted and recreated empty.
def createOrTossFile(someFilename)
  if !File.exist?(someFilename)
    system("touch #{someFilename}")
  elsif
    system("rm #{someFilename}")
    system("touch #{someFilename}")
  end
end

# Let the Parsing begin.
# processes Textfiles and attempts to build out data.json
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
  schoolIterator+=1
  outFile.write("}")
  end
  outFile.write("}")
    outFile.write("}")


  #cleanup
  inFiles.each do |inFile|
    inFile.close
  end

end

# Remove any unicode from all txt files in PWD
def cleanAscii
  txts = Dir.glob("*.txt")
  txts.each do |txt|
    #clean it from any unicode chars
    system("iconv -c -f utf-8 -t ascii #{txt}")
    system("strings #{txt}>tmpfile")
    system("strings tmpfile>#{txt}")
  end

end


fetchFiles
decodePdfs
cleanAscii
buildSaneOutput
