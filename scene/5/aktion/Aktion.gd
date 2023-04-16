extends Node3D



func set_labels(parent_):
	var data = {}
	
	for key in parent_.word.parameter.keys():
		data[key] = parent_.word.parameter[key]
	
	for key in parent_.num.parameter.keys():
		data[key] = parent_.num.parameter[key]
	
	var label_dict = {}
	
	for label in get_node("Labels").get_children():
		label_dict[label.name] = ""
	
	for key in data.keys():
		var value = data[key]
		
		for label in label_dict.keys():
			if key.find(label) != -1 || key.find(label.to_lower()) != -1:
				if label_dict[label] != "":
					label_dict[label] += "-"
				
				if typeof(value) != 4:
					value = str(value)
				
				label_dict[label] += value
	
	label_dict["Layer"] = label_dict["Layer"].replace(" in a stack", "")
	label_dict["Coverage"] = label_dict["Coverage"].replace("-", " ")
	var waffe = parent_.obj.waffe
	var damage_bot = floor(waffe.num.damage.bot*int(label_dict["Damage"])/100)
	var damage_top = floor(waffe.num.damage.top*int(label_dict["Damage"])/100)
	label_dict["Damage"] = str(damage_bot)+"-"+str(damage_top)
	
	for name_ in label_dict.keys():
		var path = "Labels/"+name_
		var label = get_node(path)
		label.text = name_ + ": "
		
		if name_ == "Name":
			label.text = ""
		
		label.text += label_dict[name_]
