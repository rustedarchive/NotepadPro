local TextChatService = game:GetService("TextChatService")

local Interface = {}

function Interface:Init(Window, WindUI, Data)
    local State = Data.State

    local HomeTab = Window:Tab({
        Title = "My Notes",
        Icon = "lucide:layout-list"
    })

    local EditorTab = Window:Tab({
        Title = "Editor",
        Icon = "lucide:edit-3"
    })

    local SnippetTab = Window:Tab({
        Title = "Snippets",
        Icon = "lucide:zap"
    })

    local SettingsTab = Window:Tab({
        Title = "Settings",
        Icon = "lucide:settings"
    })

    local function RefreshNoteList()
        HomeTab:Clear()
        
        HomeTab:Button({
            Title = "Create New Note",
            Icon = "lucide:plus-circle",
            Callback = function()
                local id = game:GetService("HttpService"):GenerateGUID(false)
                table.insert(State.Notes, 1, {
                    Id = id,
                    Title = "Untitled Note",
                    Content = "",
                    Favorite = false,
                    IsChecklist = false,
                    Tasks = {},
                    LastEdited = os.time()
                })
                Data:Save()
                RefreshNoteList()
                WindUI:Notify({
                    Title = "Note Created",
                    Content = "A new note has been added.",
                    Icon = "lucide:plus",
                    Duration = 2
                })
            end
        })
        
        HomeTab:Input({
            Title = "Search Notes",
            Placeholder = "Search by title...",
            Callback = function(val)
                State.SearchQuery = val:lower()
                RefreshNoteList()
            end
        })
        
        HomeTab:Space()
        
        for i, note in ipairs(State.Notes) do
            if State.SearchQuery == "" or note.Title:lower():find(State.SearchQuery) then
                HomeTab:Button({
                    Title = note.Title,
                    Icon = note.Favorite and "lucide:star" or "lucide:file-text",
                    Callback = function()
                        State.CurrentNoteId = note.Id
                        RefreshEditor()
                        Window:SelectTab(EditorTab)
                    end
                })
            end
        end
    end

    local function RefreshEditor()
        EditorTab:Clear()
        
        local currentNote = nil
        for _, note in ipairs(State.Notes) do
            if note.Id == State.CurrentNoteId then
                currentNote = note
                break
            end
        end
        
        if not currentNote then
            EditorTab:Label({ Title = "No note selected." })
            return
        end
        
        EditorTab:Input({
            Title = "Note Title",
            Value = currentNote.Title,
            Placeholder = "Enter title...",
            Callback = function(val)
                currentNote.Title = val
                currentNote.LastEdited = os.time()
                Data:Save()
                RefreshNoteList()
            end
        })
        
        EditorTab:Space()

        EditorTab:Toggle({
            Title = "Checklist Mode",
            Value = currentNote.IsChecklist,
            Callback = function(state)
                currentNote.IsChecklist = state
                Data:Save()
                RefreshEditor()
            end
        })

        if currentNote.IsChecklist then
            EditorTab:Button({
                Title = "Add Task",
                Icon = "lucide:check-square",
                Callback = function()
                    table.insert(currentNote.Tasks, {Text = "New Task", Done = false})
                    Data:Save()
                    RefreshEditor()
                end
            })

            for i, task in ipairs(currentNote.Tasks) do
                EditorTab:Input({
                    Title = "Task " .. i,
                    Value = task.Text,
                    Callback = function(val)
                        task.Text = val
                        Data:Save()
                    end
                })
                EditorTab:Toggle({
                    Title = "Task " .. i .. " Done",
                    Value = task.Done,
                    Callback = function(state)
                        task.Done = state
                        Data:Save()
                    end
                })
            end
        else
            EditorTab:Input({
                Title = "Note Content",
                Value = currentNote.Content,
                Placeholder = "Start typing...",
                Callback = function(val)
                    currentNote.Content = val
                    currentNote.LastEdited = os.time()
                    Data:Save()
                end
            })
        end
        
        EditorTab:Space()
        
        EditorTab:Button({
            Title = "Send to Game Chat",
            Icon = "lucide:send",
            Callback = function()
                local text = currentNote.Content
                if currentNote.IsChecklist then
                    text = "[Checklist] " .. currentNote.Title .. ": "
                    for _, t in ipairs(currentNote.Tasks) do
                        text = text .. (t.Done and "[X] " or "[ ] ") .. t.Text .. ", "
                    end
                end
                if text ~= "" then
                    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                        TextChatService.TextChannels.RBXGeneral:SendAsync(text)
                    else
                        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(text, "All")
                    end
                end
            end
        })

        EditorTab:Button({
            Title = "Permanently Delete",
            Icon = "lucide:trash-2",
            Callback = function()
                for i, note in ipairs(State.Notes) do
                    if note.Id == State.CurrentNoteId then
                        table.remove(State.Notes, i)
                        break
                    end
                end
                State.CurrentNoteId = nil
                Data:Save()
                RefreshNoteList()
                RefreshEditor()
                Window:SelectTab(HomeTab)
            end
        })
    end

    local function RefreshSnippets()
        SnippetTab:Clear()
        for i, snippet in ipairs(State.Snippets) do
            SnippetTab:Button({
                Title = snippet.Name,
                Icon = "lucide:zap",
                Callback = function()
                    local currentNote = nil
                    for _, note in ipairs(State.Notes) do
                        if note.Id == State.CurrentNoteId then
                            currentNote = note
                            break
                        end
                    end
                    if currentNote and not currentNote.IsChecklist then
                        currentNote.Content = currentNote.Content .. snippet.Content
                        Data:Save()
                        RefreshEditor()
                        WindUI:Notify({
                            Title = "Snippet Inserted",
                            Content = "Inserted '" .. snippet.Name .. "'",
                            Icon = "lucide:zap",
                            Duration = 2
                        })
                    end
                end
            })
        end
    end

    SettingsTab:Dropdown({
        Title = "Theme",
        Values = {"Dark", "Light", "Rose", "Plant", "Indigo", "Sky", "Violet", "Amber"},
        Value = State.Theme,
        Callback = function(val)
            State.Theme = val
            Window:SetTheme(val)
            Data:Save()
        end
    })

    SettingsTab:Button({
        Title = "Wipe All Data",
        Icon = "lucide:alert-octagon",
        Callback = function()
            State.Notes = {}
            State.CurrentNoteId = nil
            Data:Save()
            RefreshNoteList()
            RefreshEditor()
        end
    })

    RefreshNoteList()
    RefreshEditor()
    RefreshSnippets()
end

return Interface
