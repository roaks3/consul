
# One year from the date this repo was cloned
LAST_YEAR="2019-06-19"

# Number of files in the website directory with .mdx extension
NUM_MDX_FILES=`find ./ -name "*.mdx" | wc -l | xargs`

# Number of git tags
NUM_RELEASES=`git tag | wc -l | xargs`

# Number of git tags created in the last year
NUM_RELEASES_LAST_YEAR=`git tag -l --sort=-creatordate --format='%(creatordate:short):  %(refname:short)' | awk -v LAST_YEAR=$LAST_YEAR '{print};END {print LAST_YEAR}' | sort -r | awk "/$LAST_YEAR/ {exit} {print}" | wc -l | xargs`

# Number of git tags that end in ".0"
NUM_MINOR_RELEASES=`git tag | grep '\.0$' | wc -l | xargs`

# Number of git tags that end in ".0" created in the last year
NUM_MINOR_RELEASES_LAST_YEAR=`git tag -l --sort=-creatordate --format='%(creatordate:short):  %(refname:short)' | awk -v LAST_YEAR=$LAST_YEAR '{print};END {print LAST_YEAR}' | sort -r | awk "/$LAST_YEAR/ {exit} {print}" | grep '\.0$' | wc -l | xargs`

# Checkout stable-website from one year ago
git checkout `git rev-list -n 1 --first-parent --before="$LAST_YEAR" stable-website`

# Number of files in the website/source directory with .md extension
NUM_MD_FILES_LAST_YEAR=`find ./source -name "*.md" | wc -l | xargs`

git checkout ro.stats

echo "CONSUL"
echo "- $NUM_MDX_FILES mdx files ($(($NUM_MDX_FILES - $NUM_MD_FILES_LAST_YEAR)) in last year)"
echo "- $NUM_RELEASES releases ($NUM_RELEASES_LAST_YEAR in last year)"
echo "- $NUM_MINOR_RELEASES minor releases ($NUM_MINOR_RELEASES_LAST_YEAR in last year)"

NUM_PAGES_EVERY_RELEASE=$(($NUM_MDX_FILES * $NUM_RELEASES))

# Assume number of releases in the last year continues for 5 more years
# Assume number of mdx files included in each of those releases averages to 2x the current number of files
FUTURE_NUM_PAGES_EVERY_RELEASE=$(($NUM_PAGES_EVERY_RELEASE + ((2 * $NUM_MDX_FILES) * ($NUM_RELEASES_LAST_YEAR * 5))))

echo "- total pages for every release = $(printf "%'d" $NUM_PAGES_EVERY_RELEASE)"
echo "- total pages for every release, in 5 years = $(printf "%'d" $FUTURE_NUM_PAGES_EVERY_RELEASE)"

# Assume number of releases in the last year continues for 5 more years
# Assume number of mdx files included in each of those releases averages to 2x the current number of files
NUM_PAGES_MINOR_RELEASES=$(($NUM_MDX_FILES * $NUM_MINOR_RELEASES))
FUTURE_NUM_PAGES_MINOR_RELEASES=$(($NUM_PAGES_MINOR_RELEASES + ((2 * $NUM_MDX_FILES) * ($NUM_MINOR_RELEASES_LAST_YEAR * 5))))

echo "- total pages for minor releases = $(printf "%'d" $NUM_PAGES_MINOR_RELEASES)"
echo "- total pages for minor releases, in 5 years = $(printf "%'d" $FUTURE_NUM_PAGES_MINOR_RELEASES)"

# Assume number of mdx files included in each of the capped releases averages to 2x the current number of files
NUM_PAGES_CAPPED_RELEASES=$(($NUM_MDX_FILES * 5))
FUTURE_NUM_PAGES_CAPPED_RELEASES=$(((2 * $NUM_MDX_FILES) * 5))

echo "- total pages for 5 releases = $(printf "%'d" $NUM_PAGES_CAPPED_RELEASES)"
echo "- total pages for 5 releases, in 5 years = $(printf "%'d" $FUTURE_NUM_PAGES_CAPPED_RELEASES)"
