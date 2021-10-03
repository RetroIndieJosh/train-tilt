extends Label

class Data:
        var label
        var value

        func _init(lbl, val):
                label = lbl
                value = val

var data_list = []

func _process(_delta):
        text = ""
        for d in data_list:
                if d.value != null:
                        text += d.label + ": " + str(d.value) + "\n"

func get_data(label):
        for d in data_list:
                if d.label == label:
                        return d
        return null

func remove_data(label):
        var data = get_data(label)
        if data == null:
                return
        data_list.erase(data)

func set_data(label, value):
        var data = get_data(label)
        if data == null:
                data_list.append(Data.new(label, value))
                data = data_list.back()
                if data == null:
                        print("ERROR could not create info data for '", label, "'")
                        return
        data.value = value
