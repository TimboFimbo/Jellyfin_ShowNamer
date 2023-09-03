#!/usr/bin/env ruby

require 'pathname'

class FileSorter
    attr_accessor :folder

    def initialize(folder = "", seriesName = "", seasonNum = 1)
        @folder = folder
        @seriesName = seriesName
        @seasonNum = seasonNum
        @seasonPrefix = "S"
        @episodePrefix = "E"
        @episodeCount = 1
        @sorted
        @sortedAndTempNamed
        @acceptedFiles = [
            ".mkv",
            ".avi",
            ".m4v",
            ".mpg",
            ".mp4",
            ".wmv"
        ]
    end

    def sort_files
        @files = []
        @acceptedFiles.each do |fileExtension|
            @files += Dir[@folder + "*#{fileExtension}"]
        end

        @sorted = @files.sort
    end

    def rename_files(skips = Array.new, doubles = Array.new)
        @skips = skips
        @doubles = doubles
        @numberRenamed = 0
        @firstPassNumber = 1001

        ## Does a first pass and renames files with temporary names
        ## This prevents files rewriting each other if names already exist
        ## Would previously happen if run more than once with different episode numbers skipped
        @tempFiles = []
        @sorted.each do | fileName |
            if !File.directory? fileName
                if @acceptedFiles.include? File.extname(fileName)
                    @nameSuffix = File.extname(fileName)
                    tempName = @folder + @seriesName + "00_TempName_" + @firstPassNumber.to_s + @nameSuffix
                    File.rename(fileName, tempName)
                    @tempFiles += [tempName]
                    @firstPassNumber = @firstPassNumber+1
                end
            end
            @sortedAndTempNamed = @tempFiles
        end

        @sortedAndTempNamed.each do |fileName|
            # require 'debug'
            if !File.directory? fileName
                if @acceptedFiles.include? File.extname(fileName)
                    while @skips.include? @episodeCount.to_s
                        @episodeCount = @episodeCount+1
                    end
                    @snFormat = format('%02d', @seasonNum).to_s
                    @ecFormat = format('%02d', @episodeCount).to_s
                    @ecdFormat = format('%02d', @episodeCount+1).to_s
                    @nameSuffix = File.extname(fileName)

                    newName = @folder + @seriesName + " " + @seasonPrefix + @snFormat + @episodePrefix + @ecFormat
                    if @doubles.include? @episodeCount.to_s
                        newName += ("-" + @episodePrefix + @ecdFormat)
                        @episodeCount = @episodeCount+1
                    end
                    newName += @nameSuffix

                    File.rename(fileName, newName)
                    @episodeCount = @episodeCount+1
                    @numberRenamed = @numberRenamed+1
                end
            end
        end
        @numberRenamed
    end
end

if __FILE__ == $0
    justChecking = false
    input_array = ARGV
    if input_array.length > 0
        if input_array[0].to_s == "-c"
            justChecking = true
        end
    ARGV.clear()
    end

    ## New version that automatically gets the series name and season number
    puts "Please enter the path of the series to rename - example: /home/Tim/TV Shows/Friends (1994)"
    showFolder = gets.chomp

    seasonFolders = Pathname.new(showFolder).children.select { |c| c.directory? }.collect { |p| p.to_s + "/" }
    seasonsSorted = seasonFolders.sort

    seasonsSorted.each do |folder|    
        folderSplit = Pathname(folder).each_filename.to_a
        seasonNum = folderSplit[-1].split[-1]
        seriesName = folderSplit[-2]

        puts "Folder path: " + folder
        puts "Series name: " + seriesName
        puts "Season number: " + seasonNum

        ## Sort the files and ask for confirmation before renaming
        fs = FileSorter.new(folder, seriesName, seasonNum)
        sortedFiles = fs.sort_files

        if sortedFiles.length > 0
            puts "Here are the files found:"
            puts sortedFiles
            puts ""

            if !justChecking
                puts "Enter R to Rename, S to Skip Numbers, D to add Double Episodes, or C to Cancel"
                likeToRename = gets.chomp

                if likeToRename[0,1] == 'R' || likeToRename[0,1] == 'r'
                    numberOfFiles = fs.rename_files
                    puts numberOfFiles.to_s + " files renamed"
                    puts ""
                elsif likeToRename[0,1] == 'S' || likeToRename[0,1] == 's'
                    puts "Please enter episode numbers to skip - example: 6 13 21"
                    filesToSkip = gets.chomp.split(' ')
                    numberOfFiles = fs.rename_files(filesToSkip, Array.new)
                    puts numberOfFiles.to_s + " files renamed"
                    puts ""
                elsif likeToRename[0,1] == 'D' || likeToRename[0,1] == 'd'
                    puts "Please enter the first number of each double episode - example: entering 24 results in E24-E25"
                    doubleEpisodes = gets.chomp.split(' ')
                    numberOfFiles = fs.rename_files(Array.new, doubleEpisodes)
                    puts numberOfFiles.to_s + " files renamed"
                    puts ""
                else
                    puts "Files not renamed"
                    puts ""
                end
            end
        else
            puts "No files found!"
            puts ""
        end
    end
end