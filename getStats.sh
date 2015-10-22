# files=$(git ls-files | head -n1)
files=$(find . -name "*.cs" \
    -not -regex ".*\/\(packages\|obj\|bin\|Migrations\)\/.*" \
    -not -name "*AssemblyInfo.cs" -type f \
    -not -name "*Designer.cs" )
dateToUse=$(date --date="900 days ago" +"%Y-%m-%d")
function getAuthors()
{
    for file in ${files}
    do 
        if [ 0 -eq "$(git log --format=oneline --since=${dateToUse} origin/develop ${file} | wc -l)" ]
        then
            continue
        fi
        git blame -w --line-porcelain "${file}" \
            | sed -n 's/^author //p';
    done
}
#[{name: "Name", y: 10}]
# getAuthors ${files} 
getAuthors ${files} | sort | uniq -c | awk 'BEGIN { print "[" } { printf("{name: \"%s\", y: %s},", $2, $1) } END { print "]" }' >> gitout.txt

