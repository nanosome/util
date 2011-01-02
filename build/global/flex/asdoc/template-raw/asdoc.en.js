var terms = {
	Frames: "Frames",
	NoFrames: "No Frames",
	ShowProperty: "Show Inherited Properties",
	HideProperty: "Hide Inherited Properties",
	ShowProtectedProperty: "Show Inherited Propertected Properties",
	HideProtectedProperty: "Hide Inherited Propertected Properties"
};

$(["Constant","Protected Constant","Method","Protected Method","Event","Style","Skin Part","Skin State","Effect"]).each( function() {
	var value = this;
	var valueNoSpace = value.split(" ").join("");
	terms["Hide"+valueNoSpace] = "Hide Inherited "+value+"s";
	terms["Show"+valueNoSpace] = "Show Inherited "+value+"s";
});