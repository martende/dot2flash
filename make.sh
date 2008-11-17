#/home/belka/flex/bin/mxmlc MainLayout.mxml
#dot -Tdot test.dot > test.xdot
#dot -Tpng test.dot > test.png
cd /home/belka/nodegraph;
perl get_data.pl 10
cd /home/belka/FLash/dotxml
perl dot2xml.pl /home/belka/nodegraph/data.dot > test.xml
cp MainLayout.swf test.xml test.png /usr/local/apache_sichtfenster/htdocs/nodegraph
