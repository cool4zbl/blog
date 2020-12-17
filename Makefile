gen-myhz:
	rm -r 2017-07-12-to-myhz
	cp -r ~/my_web_dev/100days/dist ./2017-07-12-to-myhz

gen-resume:
	rm -r resume
	cp -r ../re-Resume/dist ./resume
	cp -r ../re-Resume/download ./resume/download
	git add .
	git commit -m 'Update resume'
	git push

gen-resume2020:
	rm -rf resume-2020
	cp -r ../re-Resume/dist ./resume-2020

gen-inspiring:
	rm -r inspiring-me
	cp -r ~/my_web_dev/inspiring-me/dist ./inspiring-me

