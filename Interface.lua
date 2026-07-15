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
                    Category = "General",
                    Favorite = false,
                    LastEdited = os.time()
                })
                Data:Save()
                RefreshNoteList()
                WindUI:Notify({
                    Title = "Note Created",
                    Content = "A new note has been added to your collection.",
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
        
        local foundAny = false
        for i, note in ipairs(State.Notes) do
            if State.SearchQuery == "" or note.Title:lower():find(State.SearchQuery) then
                foundAny = true
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
        
        if not foundAny and State.SearchQuery ~= "" then
            HomeTab:Label({ Title = "No notes match your search." })
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
            EditorTab:Label({ Title = "No note selected. Select a note from 'My Notes' to begin editing." })
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
        
        EditorTab:Space()
        
        EditorTab:Toggle({
            Title = "Mark as Favorite",
            Value = currentNote.Favorite,
            Callback = function(state)
                currentNote.Favorite = state
                Data:Save()
                RefreshNoteList()
            end
        })
        
        EditorTab:Button({
            Title = "Duplicate This Note",
            Icon = "lucide:copy-plus",
            Callback = function()
                local id = game:GetService("HttpService"):GenerateGUID(false)
                table.insert(State.Notes, 1, {
                    Id = id,
                    Title = currentNote.Title .. " (Copy)",
                    Content = currentNote.Content,
                    Category = currentNote.Category,
                    Favorite = currentNote.Favorite,
                    LastEdited = os.time()
                })
                Data:Save()
                RefreshNoteList()
                WindUI:Notify({
                    Title = "Duplicated",
                    Content = "Note duplicated successfully.",
                    Icon = "lucide:copy",
                    Duration = 2
                })
            end
        })

        EditorTab:Button({
            Title = "Send to Game Chat",
            Icon = "lucide:send",
            Callback = function()
                if currentNote.Content ~= "" then
                    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                        local channel = TextChatService.TextChannels.RBXGeneral
                        channel:SendAsync(currentNote.Content)
                    else
                        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(currentNote.Content, "All")
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
                WindUI:Notify({
                    Title = "Note Deleted",
                    Content = "The note has been removed.",
                    Icon = "lucide:trash",
                    Duration = 2
                })
            end
        })
    end

    SettingsTab:Dropdown({
        Title = "Interface Theme",
        Values = {"Dark", "Light", "Rose", "Plant", "Indigo", "Sky", "Violet", "Amber"},
        Value = "Dark",
        Callback = function(val)
            Window:SetTheme(val)
        end
    })

    SettingsTab:Toggle({
        Title = "Background Auto-Save",
        Value = true,
        Callback = function(state)
            State.AutoSave = state
        end
    })

    SettingsTab:Button({
        Title = "Clear All Local Data",
        Icon = "lucide:alert-octagon",
        Callback = function()
            State.Notes = {}
            State.CurrentNoteId = nil
            Data:Save()
            RefreshNoteList()
            RefreshEditor()
            WindUI:Notify({
                Title = "Data Cleared",
                Content = "All local notes have been wiped.",
                Icon = "lucide:refresh-ccw",
                Duration = 5
            })
        end
    })

    RefreshNoteList()
    RefreshEditor()

    task.spawn(function()
        while true do
            task.wait(30)
            if State.AutoSave then
                Data:Save()
            end
        end
    end)
end

return Interface
