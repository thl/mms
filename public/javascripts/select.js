var ie=document.all;
var nn6=document.getElementById&&!document.all;
var disabled = false;

function uncheckAll(checkBoxes)
{
	for (i=0; i<checkBoxes.length; i++)
		if (checkBoxes[i].checked)
			checkBoxes[i].checked = false;
		else if (checkBoxes[i].disabled)
			checkBoxes[i].disabled = false;
	disabled = false
}

function updateChecked(checkBoxes, statusName, button, max, hidden)
{
	checked = 0;
	var status = document.getElementById(statusName);
	var hiddenField;
	
	for (i=0; i<checkBoxes.length; i++)
		if (checkBoxes[i].checked)
		{
			checked++;
			hiddenFieldName = hidden + checked;
			hiddenField = document.getElementById(hiddenFieldName);
			hiddenField.value = checkBoxes[i].value;
		}
	status.innerHTML = "Faltan " + (max-checked) + "/" + max + ".";
	if (checked>=max)
	{
		button.disabled = false;
		if (!disabled)
		{
			disabled = true;
			for (i=0; i<checkBoxes.length; i++)
				if (!checkBoxes[i].checked)
					checkBoxes[i].disabled = true;
		}
	}
	else
	{
		button.disabled = true;
		if (disabled)
		{
			disabled = false;
			for (i=0; i<checkBoxes.length; i++)
				if (checkBoxes[i].disabled)
					checkBoxes[i].disabled = false;			
		}
	}
}

function selectAll(name)
{
	var select = document.getElementById(name);
	select.multiple = true;
	var options = select.options;
	for (i=0; i<select.length; i++)
	{
		options[i].selected=true;
	}
}

function moveSelected(orig, dest)
{
	var selectOrig = document.getElementById(orig);
	var selectDest = document.getElementById(dest);
	var i = 0;
	while (i<selectOrig.length)
	{
		option = selectOrig.options[i];
		if (option.selected)
		{
			option.selected = false;
			selectOrig.remove(i);
			if (nn6)
			{
				selectDest.length = selectDest.length+1;
				selectDest.options[selectDest.length-1] = option;
			}
			else selectDest.add(option);
		}
		else i++;
	}
}

function enableAndCopySelected (list, text, button)
{
	if (list.selected != -1)
	{
		button.disabled = false;
		var textField = document.getElementById(text);
		textField.value = list.value;
	}
	else button.disabled = true;
}