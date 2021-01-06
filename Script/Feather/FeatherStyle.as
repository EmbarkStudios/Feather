// Copyright 2020 Cadic AB. All Rights Reserved.
// @URL     https://github.com/Temaran/Feather
// @Author  Fredrik Lindh [Temaran] (temaran@gmail.com)
////////////////////////////////////////////////////////////

UCLASS(Abstract)
class UFeatherWindowStyle : UUserWidget
{
	// Set this to your UFeatherWindow
	UPROPERTY(Category = "Feather|Style")
	UWidget ActualWindow;

	UFUNCTION(Category = "Feather|Style", BlueprintEvent, BlueprintPure)
	UNamedSlot GetWindowContentSlot() const { return nullptr; }
};

event void FButtonClickedWithContextSignature(UFeatherButtonStyle ThisButton);
UCLASS(Abstract)
class UFeatherButtonStyle : UUserWidget
{
	UPROPERTY(Category = "Feather|Style")
	bool bUseStyleOverride;

	UPROPERTY(Category = "Feather|Style", meta = (EditCondition = bUseStyleOverride))
	FButtonStyle OverrideButtonStyle;
	
	UPROPERTY(Category = "Feather|Style", meta = (EditCondition = bUseStyleOverride))
	FLinearColor OverrideButtonTint;

	UPROPERTY(Category = "Feather|Style")
	FButtonClickedWithContextSignature OnClickedWithContext;

	UFUNCTION(Category = "Feather|Style", BlueprintEvent, BlueprintPure)
	UButton GetButtonWidget() const { return nullptr; }

	UFUNCTION(BlueprintOverride)
	void PreConstruct(bool IsDesignTime)
	{
		SetStyleOverride();
	}
	
	UFUNCTION(BlueprintOverride)
	void Construct()
	{
		SetStyleOverride();
	}

	UFUNCTION(Category = "Feather|Style", BlueprintEvent, BlueprintCallable)
	void ClickedWithContext(UFeatherButtonStyle ThisButton)
	{
		OnClickedWithContext.Broadcast(ThisButton);
	}

	void SetStyleOverride()
	{
		if(bUseStyleOverride)
		{
			GetButtonWidget().SetStyle(OverrideButtonStyle);
			GetButtonWidget().SetBackgroundColor(OverrideButtonTint);
		}
	}
};

UCLASS(Abstract)
class UFeatherCheckBoxStyle : UUserWidget
{
	UFUNCTION(Category = "Feather|Style", BlueprintEvent, BlueprintPure)
	UCheckBox GetCheckBoxWidget() const { return nullptr; }

	UFUNCTION(Category = "Feather|Style", BlueprintPure)
	bool IsChecked() const
	{		
		return GetCheckBoxWidget().IsChecked();
	}

	UFUNCTION(Category = "Feather|Style")
	void SetIsChecked(bool bNewCheckedState)
	{		
		GetCheckBoxWidget().SetIsChecked(bNewCheckedState);
		
		// CheckStateChanged is not called for checkboxes when set from code
		GetCheckBoxWidget().OnCheckStateChanged.Broadcast(bNewCheckedState);
	}
};

UCLASS(Abstract)
class UFeatherComboBoxStyle : UUserWidget
{
	UFUNCTION(Category = "Feather|Style", BlueprintEvent, BlueprintPure)
	UComboBoxString GetComboBoxWidget() const { return nullptr; }
	
	UFUNCTION(Category = "Feather|Style", BlueprintPure)
	FString GetSelectedOption() const
	{
		return GetComboBoxWidget().GetSelectedOption();
	}
	
	UFUNCTION(Category = "Feather|Style", BlueprintPure)
	int GetSelectedIndex() const
	{
		return GetComboBoxWidget().GetSelectedIndex();
	}

	UFUNCTION(Category = "Feather|Style")
	void SetSelectedOption(FString NewSelectedOption)
	{
		GetComboBoxWidget().SetSelectedOption(NewSelectedOption);
	}
	
	UFUNCTION(Category = "Feather|Style")
	void SetSelectedIndex(int NewSelectedIndex)
	{
		GetComboBoxWidget().SetSelectedIndex(NewSelectedIndex);
	}
};

UCLASS(Abstract)
class UFeatherSliderStyle : UUserWidget
{
	UFUNCTION(Category = "Feather|Style", BlueprintEvent, BlueprintPure)
	USlider GetSliderWidget() const { return nullptr; }
	
	UFUNCTION(Category = "Feather|Style", BlueprintPure)
	float GetValue() const
	{
		return GetSliderWidget().GetValue();
	}

	UFUNCTION(Category = "Feather|Style")
	void SetValue(float NewValue)
	{
		GetSliderWidget().SetValue(NewValue);
		GetSliderWidget().OnValueChanged.Broadcast(NewValue);
	}
};

UCLASS(Abstract)
class UFeatherTextBlockStyle : UUserWidget
{
	UFUNCTION(Category = "Feather|Style", BlueprintEvent, BlueprintPure)
	UTextBlock GetTextWidget() const { return nullptr; }
	
	UFUNCTION(Category = "Feather|Style", BlueprintPure)
	FText GetText() const
	{
		return GetTextWidget().GetText();
	}

	UFUNCTION(Category = "Feather|Style")
	void SetText(FText NewText)
	{
		GetTextWidget().SetText(NewText);
	}
};

UCLASS(Abstract)
class UFeatherEditableTextStyle : UUserWidget
{
	UFUNCTION(Category = "Feather|Style", BlueprintEvent, BlueprintPure)
	UEditableText GetEditableText() const { return nullptr; }
	
	UFUNCTION(Category = "Feather|Style", BlueprintPure)
	FText GetText() const
	{
		return GetEditableText().GetText();
	}

	UFUNCTION(Category = "Feather|Style")
	void SetText(FText NewText)
	{
		GetEditableText().SetText(NewText);
		
		// Not called when set from code
		GetEditableText().OnTextChanged.Broadcast(NewText);
		GetEditableText().OnTextCommitted.Broadcast(NewText, ETextCommit::Default);
	}
};

UCLASS(Abstract)
class UFeatherMultiLineEditableTextStyle : UUserWidget
{
	UFUNCTION(Category = "Feather|Style", BlueprintEvent, BlueprintPure)
	UMultiLineEditableText GetEditableText() const { return nullptr; }
	
	UFUNCTION(Category = "Feather|Style", BlueprintPure)
	FText GetText() const
	{
		return GetEditableText().GetText();
	}

	UFUNCTION(Category = "Feather|Style")
	void SetText(FText NewText)
	{
		GetEditableText().SetText(NewText);
		
		// Not called when set from code
		GetEditableText().OnTextChanged.Broadcast(NewText);
		GetEditableText().OnTextCommitted.Broadcast(NewText, ETextCommit::Default);
	}
};

// This is the main style container. You can add multiple styles and identify them by name. Default styles have an empty identifier
struct FFeatherStyle
{
	UPROPERTY(Category = "Feather|Style")
	TMap<FName, TSubclassOf<UFeatherWindowStyle>> WindowStyles;

	UPROPERTY(Category = "Feather|Style")
	TMap<FName, TSubclassOf<UFeatherButtonStyle>> ButtonStyles;

	UPROPERTY(Category = "Feather|Style")
	TMap<FName, TSubclassOf<UFeatherCheckBoxStyle>> CheckBoxStyles;

	UPROPERTY(Category = "Feather|Style")
	TMap<FName, TSubclassOf<UFeatherComboBoxStyle>> ComboBoxStyles;

	UPROPERTY(Category = "Feather|Style")
	TMap<FName, TSubclassOf<UFeatherSliderStyle>> SliderStyles;

	UPROPERTY(Category = "Feather|Style")
	TMap<FName, TSubclassOf<UFeatherTextBlockStyle>> TextBlockStyles;

	UPROPERTY(Category = "Feather|Style")
	TMap<FName, TSubclassOf<UFeatherEditableTextStyle>> EditableTextStyles;
	
	UPROPERTY(Category = "Feather|Style")
	TMap<FName, TSubclassOf<UFeatherMultiLineEditableTextStyle>> MultiLineEditableTextStyles;
};
