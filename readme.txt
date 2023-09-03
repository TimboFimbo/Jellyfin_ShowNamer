A program for renaming TV shows for use with home media servers, such as Jellyfin or OSMC.
Works on Linux (probably Windows and Mac also, but haven't tested yet).
This is an adaptation of an animation namer I made for the Flipper Zero, which you can
find at https://github.com/TimboFimbo/Flipper_AnimNamer

One run, pass in the path of a folder containing TV show seasons.
The episodes within will be renamed in order to "SeriesName (SeriesDate) S01E01",
which is the format used by programs retrieving metadata from TMDB. You can also
skip episode numbers or run the program just to check which video files are found,
and I'll probably add more options as I think of them.

I've tested this to a certain extent, but you take any resposibility
into your own hands if you use this program. I haven't accidentally renamed 
any files, and you get to confirm the files set to be renamed before anything
happens, but try to be careful anyway. It doesn't go through folders
recursively, so it shouldn't be able to do too much damage, but I'd still
recommend having a backup of the video files before you use this.

Also, I haven't spent much time with Ruby, so I'm sure there are numerous bugs I 
haven't found yet and many things that could be changed or optimized, so I'll 
update as I use it more.

How to Download and Use the Jellyfin Show Namer:

1. Before starting, organise your episodes in the following manner: 

    - Each show should be within a folder titled with the show name and date in 
       brackets, such as 'Friends (1994)'.

    - Within these folders, each season folder should be named 'Season 1', 'Season 2',
       and so on.

    - The names of the episodes within the folders doesn't matter (that's what we're
       about to fix), but they must be in alpahbetical order or they will be numbered
       incorrectly (don't worry if you miss one - you get to confirm before renaming).

    - Here's an example of this structure, showing how things should look before running
       the program (assuming the shows are within a folder called 'TV Shows'):

      ~/TV Shows
        |
        ----> .../Friends (1994)
        |     	  |
        |     	  ----> .../Season 1
        |     	  |     	|
        |     	  |     	----> .../Friends_DVDRip_S01_E01.mkv
        |     	  |     	|
        |     	  |     	----> .../Friends_DVDRip_S01_E02.mkv
        |     	  |
        |     	  ----> .../Season 2
        |               	|
        |               	----> .../Friends iTunes S02E01.avi
        |               	|
        |               	----> .../Friends iTunes S02E02.avi
        |
        ----> .../Spaced (1999)
                  |
                  ----> .../Season 1
                  |     	|
                  |     	----> .../Spaced_1999_Season1_Ep1.m4v
                  |     	|
                  |     	----> .../Spaced_1999_Season1_Ep2.m4v
                  |
                  ----> .../Season 2
                            |
                            ----> .../spaced-comedy-s02e01.mpg
                            |
                            ----> .../spaced-comedy-s02e02.mpg

    - So one episode would be: 
       ~/TV Shows/Friends (1994)/Season 1/Friends_DVDRip_S01_E01.mkv

2. You must have Ruby installed. Check this by opening a Terminal window and
    typing 'ruby --version'. If you don't get a version number, look up how to
    install for your OS.

3. Once installed, navigate to the folder you wish the application to reside in.
    This can be done using the same Terminal on Linux or Mac. Windows users may 
    have to hit the Windows key and run 'Start Command Prompt with Ruby'.

4. Download the application as a .zip file, then unzip, or use Git by typing 
    'git clone https://github.com/TimboFimbo/Jellyfin_ShowNamer'. Once complete,
    use 'cd Jellyfin_ShowNamer' to enter the folder.

5. Type 'ls -la' to see the files and their permissions. If showNamer.rb is not
    executable (shown as a series of 'w's and 'r's to the left of the file name, but
    no 'x's) then type 'chmod +x showRenamer.rb'. Repeating the 'ls -la' command
    should now show it as executable (there will be 'x's now).

6. You can now type './showRenamer.rb' or 'ruby ./showRenamer.rb' to start the application. 
    When prompted, enter the path of the folder containing the show to rename. 
    This must be the absolute path, not the relative one. For example, for a user 
    called 'Bob' who has a folder called 'TV Shows' in his Home folder would type 
    the following (try with a formward slash at the end if nothing found):

    Linux:    /home/Bob/TV Shows/Friends (1994)
    Mac:      /Users/Bob/TV Shows/Friends (1994)
    Windows:  c:/Users/Bob/TV Shows/Friends (1994)

7. If everything goes correctly, you will now be presented with each season's episodes, one season 
    at a time. Check that all episodes are listed and in order and if so, type 'r' to rename. You
    can also type 's' to enter episode numbers to skip, which is good for missing files, 'd' to enter
    double episodes ('21' becomes S02E21-22), or 'c' to cancel and move onto the next season.

Extra Information:

   - By starting the program with the argument -c (./showRenamer.rb -c) you will start in 'check
      mode', which will list every episode found within the folder (still by season), without
      prompting to rename. This allows a quick check for missing or mis-ordered episodes before
      running the program for real.

   - So far, I have only added video formats I've used, so if you find files missing, try adding
      their extensions into the '@acceptedFiles' array towards the top of the script then running 
      again.

   - Episodes that come in twos, such as with shorter cartoons, must currently be entered as double
       episodes, one at a time, so I may add an 'all doubles' option. There is also no way to skip and
       add doubles to the same season, so I'll add a syntax for that (possibly '-s 2 4 -d 5', which
       would skip episodes 2 and 4 and turn episode 5 into E05-E06)

   - Finally, I'm currenty writing a setup guide for Jellyfin Media Server on Raspberry Pi, which
      includes this program, so I'll link to that once it's done. There are plenty of great
      guides out there, and I fully admit to taking entire sections from them, but I wanted
      to compile the program setup along with mounting of external drives, media naming and
      organisation, quick wireless transfer, and other little things to help new users. Look for
      that soon :)
