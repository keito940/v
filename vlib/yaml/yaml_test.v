import (
	yaml
	json
	testml
)

fn test_229Q(){
	test_data := http.get('https://github.com/yaml/yaml-test-suite/blob/master/test/229Q.tml')or{
		println('failed fetch to data from /test/229Q.tml')
	}
	
	assert testml_parse(test_data)
}

fn test_236B(){
	test_data := http.get('https://github.com/yaml/yaml-test-suite/blob/master/test/236B.tml')or{
		println('failed fetch to data from /test/236B.tml')
	}
}

fn test_26DV(){
	test_data := http.get('https://github.com/yaml/yaml-test-suite/blob/master/test/26DV.tml')or{
		println('failed fetch to data from /test/26DV.tml')
	}
}