#!/bin/bash
# Downloads videos from youtube based on selection from http://thebestofyoutube.com
# (c) Ken Fallon http://kenfallon.com
# Released under the CC-0

maxtodownload=10
savepath="~/media/vids/"
savedir="${savepath}/$(\date -u +%Y-%m-%d_%H-%M-%SZ_%A)"
mkdir -p ${savedir}
logfile="${savepath}/downloaded.log"

# Gather the list
seq 1 ${maxtodownload} | while read videopage;
do 
  thisvideolist=$(wget --quiet "http://bestofyoutube.com/index.php?page=${videopage}" -O - | 
  grep 'www.youtube.com/embed/' | 
  sed 's#^.*www.youtube.com/embed/##' | 
  awk -F '"|?' '{print "http://www.youtube.com/watch?v="$1}')
  for thisvideo in $(echo $thisvideolist);
  do 
    if [ "$( grep "${thisvideo}" "${logfile}" | wc -l )" -eq 0 ];
    then
      echo "Found the new video ${thisvideo}"
      echo ${thisvideo} >> ${logfile}_todo
    else
      echo "Already downloaded ${thisvideo}"
    fi
  done
done

# Download the list
if [ -e ${logfile}_todo ];
then
  tac ${logfile}_todo | youtube-dl --batch-file - --ignore-errors --no-mtime --restrict-filenames --max-quality --format mp4 --write-auto-sub -o ${savedir}'/%(autonumber)s-%(title)s-%(id)s.%(ext)s'
  cat ${logfile}_todo >> ${logfile}
  rm ${logfile}_todo
fi
